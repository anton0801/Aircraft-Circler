import SwiftUI
import SpriteKit

// MARK: To do: доделать: 2. спавн колец, монет и препятствий, 3. коллизий, 4. win/lose/pause

class CirclerGameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Int
    
    var backgroundLayers: [(node: SKSpriteNode, speed: CGFloat)] = []
    
    var objectivePassedCount = 0 {
        didSet {
            objectiveLabel.text = "\(objectivePassedCount)/\(objectiveMax)"
            if objectivePassedCount == objectiveMax {
                showWinView()
            }
        }
    }
    var objectiveMax: Int {
        get {
            return 20 + (10 * level)
        }
    }
    private var objectivePassed: [String] = []
    private var spawnedCirclers: [SKNode] = []
    
    var errors = 0 {
        didSet {
            setUpErrors()
            if errors == 2 {
                showLoseView()
            }
        }
    }
    private var errorNodes: [SKNode] = []
    
    private var objectiveLabel: SKLabelNode!
    
    private var levelLabel: SKLabelNode {
        get {
            let node = SKLabelNode(text: "LEVEL \(level)")
            node.fontName = "Aviator-Bold"
            node.fontSize = 72
            node.fontColor = .white
            node.zPosition = 2
            node.position = CGPoint(x: size.width / 2, y: size.height - 240)
            return node
        }
    }
    private var levelLabel2: SKLabelNode {
        get {
            let node = SKLabelNode(text: "LEVEL \(level)")
            node.fontName = "Aviator-Bold"
            node.fontSize = 73
            node.fontColor = .black
            node.zPosition = 1
            node.position = CGPoint(x: size.width / 2, y: size.height - 245)
            return node
        }
    }
    
    private var pauseBtn: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "pause_btn")
            node.position = CGPoint(x: size.width / 2, y: 50)
            node.size = CGSize(width: 100, height: 100)
            node.name = "pause_btn"
            return node
        }
    }
    
    private var money = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            UserDefaults.standard.set(money, forKey: "money")
            moneyLabel.text = "\(money)"
        }
    }
    private var moneyLabel: SKLabelNode!
    
    private var plane: SKSpriteNode!
    
    init(level: Int) {
        self.level = level
        super.init(size: CGSize(width: 1335, height: 750))
    }
    
    func restartGame() -> CirclerGameScene {
        let n = CirclerGameScene(level: level)
        view?.presentScene(n)
        return n
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var speedObsta: Double {
        get {
            var res = 5.5
            if level >= 2 && level < 4 {
                res = 5
            } else if level == 4 {
                res = 4.5
            } else if level == 5 {
                res = 4
            } else {
                res = 3.5
            }
            return res
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createParallaxBackground()
        
        addChild(levelLabel)
        addChild(levelLabel2)
        addChild(pauseBtn)
        
        createJostik()
        createPlane()
        createHeader()
        
        spawnCircler()
        let _ = Timer.scheduledTimer(withTimeInterval: speedObsta + 0.5, repeats: true) { _ in
            self.spawnCircler()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 7, repeats: true) { _ in
            self.spawnCoins()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            self.spawnObstacle()
        }
    }
    
    private func spawnCoins() {
        if !self.isPaused {
            let nodeY = CGFloat.random(in: (250)...(size.height - 270))
            let node = SKSpriteNode(imageNamed: "coin")
            node.position = CGPoint(x: size.width, y: nodeY)
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height / 2)
            node.physicsBody?.isDynamic = true
            node.size = CGSize(width: 60, height: 60)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = 2
            node.physicsBody?.collisionBitMask = 1
            node.physicsBody?.contactTestBitMask = 1
            addChild(node)
            let actionmoving = SKAction.move(to: CGPoint(x: -100, y: nodeY), duration: speedObsta)
            node.run(SKAction.sequence([actionmoving, SKAction.removeFromParent()]))
        }
    }
    
    private func spawnObstacle() {
        if !self.isPaused {
            let nodeY = CGFloat.random(in: (250)...(size.height - 270))
            let node = SKSpriteNode(imageNamed: "obstacle")
            node.position = CGPoint(x: size.width, y: nodeY)
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = true
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = 3
            node.physicsBody?.collisionBitMask = 1
            node.physicsBody?.contactTestBitMask = 1
            addChild(node)
            let actionmoving = SKAction.move(to: CGPoint(x: -100, y: nodeY), duration: speedObsta)
            node.run(SKAction.sequence([actionmoving, SKAction.removeFromParent()]))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        
        if (a.categoryBitMask == 1 && b.categoryBitMask == 2) ||
            (a.categoryBitMask == 2 && b.categoryBitMask == 1) {
            let bBody: SKPhysicsBody
            
            if a.categoryBitMask == 1 {
                bBody = b
            } else {
                bBody = a
            }
            
            bBody.node?.removeFromParent()
            
            money += 5
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        if (a.categoryBitMask == 1 && b.categoryBitMask == 3) ||
            (a.categoryBitMask == 3 && b.categoryBitMask == 1) {
            errors += 1
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            let bBody: SKPhysicsBody
            
            if a.categoryBitMask == 1 {
                bBody = b
            } else {
                bBody = a
            }
            
            bBody.node?.removeFromParent()
        }
    }
    
    private var circlerSizes = [
        CGSize(width: 40, height: 40),
        CGSize(width: 50, height: 50),
        CGSize(width: 70, height: 70),
        CGSize(width: 90, height: 90),
        CGSize(width: 110, height: 110),
        CGSize(width: 130, height: 130),
    ]
    
    private func spawnCircler() {
        if !isPaused {
            if spawnedCirclers.count <= objectiveMax {
                let nodeY = CGFloat.random(in: (250)...(size.height - 270))
                let node = SKSpriteNode(imageNamed: "circler")
                node.name = "circler_\(UUID().uuidString)"
                node.size = circlerSizes.randomElement() ?? CGSize(width: 70, height: 70)
                node.position = CGPoint(x: size.width, y: nodeY)
                addChild(node)
                let actionmoving = SKAction.move(to: CGPoint(x: -100, y: nodeY), duration: speedObsta)
                node.run(SKAction.sequence([actionmoving, SKAction.removeFromParent()]))
                spawnedCirclers.append(node)
            } else {
                showLoseView()
            }
        }
    }
    
    private func createHeader() {
        let moneyBack = SKSpriteNode(imageNamed: "credits_back")
        moneyBack.position = CGPoint(x: 200, y: size.height - 80)
        moneyBack.size = CGSize(width: 300, height: 200)
        addChild(moneyBack)
        
        moneyLabel = SKLabelNode(text: "\(money)")
        moneyLabel.fontName = "Aviator-Bold"
        moneyLabel.fontSize = 52
        moneyLabel.fontColor = .white
        moneyLabel.position = CGPoint(x: 260, y: size.height - 100)
        addChild(moneyLabel)
        
        let objectiveBack = SKSpriteNode(imageNamed: "objective_back")
        objectiveBack.position = CGPoint(x: size.width / 2, y: size.height - 85)
        objectiveBack.size = CGSize(width: 300, height: 170)
        addChild(objectiveBack)
        
        objectiveLabel = SKLabelNode(text: "\(objectivePassedCount)/\(objectiveMax)")
        objectiveLabel.position = CGPoint(x: size.width / 2, y: size.height - 105)
        objectiveLabel.fontName = "Aviator-Bold"
        objectiveLabel.fontSize = 62
        objectiveLabel.fontColor = .white
        addChild(objectiveLabel)
        
        let errorsBack = SKSpriteNode(imageNamed: "objective_back")
        errorsBack.position = CGPoint(x: size.width - 200, y: size.height - 85)
        errorsBack.size = CGSize(width: 230, height: 170)
        addChild(errorsBack)
        
        setUpErrors()
    }
    
    private func setUpErrors() {
        for error in errorNodes {
            error.removeFromParent()
        }
        errorNodes = []
        for i in 1...2 {
            var errorNodeName = "not_error"
            if errors >= i {
                errorNodeName = "yes_error"
            }
            let node = SKSpriteNode(imageNamed: errorNodeName)
            let startX = size.width - 325
            node.position = CGPoint(x: startX + CGFloat(85 * i), y: size.height - 85)
            node.size = CGSize(width: 80, height: 80)
            addChild(node)
        }
    }
    
    private func createPlane() {
        plane = SKSpriteNode(imageNamed: "plane")
        plane.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.collisionBitMask = 2 | 3
        plane.physicsBody?.contactTestBitMask = 2 | 3
        plane.size = CGSize(width: 120, height: 51)
        plane.name = "plane"
        addChild(plane)
    }
    
    private func createJostik() {
        let jostikUp = SKSpriteNode(imageNamed: "jostik_up")
        jostikUp.position = CGPoint(x: 120, y: 200)
        jostikUp.name = "jostik_up"
        jostikUp.size = CGSize(width: 52, height: 102)
        addChild(jostikUp)
        
        let jostikRight = SKSpriteNode(imageNamed: "jostik_right")
        jostikRight.position = CGPoint(x: 170, y: 145)
        jostikRight.name = "jostik_right"
        jostikRight.size = CGSize(width: 90, height: 52)
        addChild(jostikRight)
        
        let jostikLeft = SKSpriteNode(imageNamed: "jostik_left")
        jostikLeft.position = CGPoint(x: 70, y: 145)
        jostikLeft.name = "jostik_left"
        jostikLeft.size = CGSize(width: 90, height: 52)
        addChild(jostikLeft)
        
        let jostikBottom = SKSpriteNode(imageNamed: "jostik_bottom")
        jostikBottom.position = CGPoint(x: 120, y: 100)
        jostikBottom.name = "jostik_bottom"
        jostikBottom.size = CGSize(width: 52, height: 102)
        addChild(jostikBottom)
    }
    
    func createParallaxBackground() {
       addBackgroundLayer(imageName: "game_background", speed: 3, zPosition: -3)
    }
    
    func addBackgroundLayer(imageName: String, speed: CGFloat, zPosition: CGFloat) {
        let texture = SKTexture(imageNamed: imageName)
        
        for i in 0..<3 {
            let node = SKSpriteNode(texture: texture)
            node.anchorPoint = CGPoint.zero
            node.position = CGPoint(x: CGFloat(i) * node.size.width, y: 0)
            node.zPosition = zPosition
            node.size = CGSize(width: self.size.width, height: self.size.height)
            addChild(node)
            backgroundLayers.append((node: node, speed: speed))
        }
    }
    
    private var errorsCounted: [String] = []
    
    override func update(_ currentTime: TimeInterval) {
        for layer in backgroundLayers {
            layer.node.position.x -= layer.speed
            
            if layer.node.position.x <= -layer.node.size.width {
                layer.node.position.x += layer.node.size.width * 2
            }
        }
        
        for spawnedCircler in spawnedCirclers {
            if spawnedCircler.position.x > 0 {
                if spawnedCircler.intersects(plane) {
                    if !objectivePassed.contains(spawnedCircler.name!) {
                        objectivePassed.append(spawnedCircler.name!)
                        objectivePassedCount += 1
                    }
                }
            } else {
                if !objectivePassed.contains(spawnedCircler.name!) {
                    if !errorsCounted.contains(spawnedCircler.name!) {
                        errors += 1
                        errorsCounted.append(spawnedCircler.name!)
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.warning)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch != nil {
            let loc = touch!.location(in: self)
            let object = atPoint(loc)
            
            if object.name == "jostik_up" {
                movePlaneUpDown(isDown: false)
                object.alpha = 0.8
            }
            
            if object.name == "jostik_bottom" {
                movePlaneUpDown(isDown: true)
                object.alpha = 0.8
            }
            
            if object.name == "jostik_left" {
                movePlaneLeftRight(isRight: false)
                object.alpha = 0.8
            }
            
            if object.name == "jostik_right" {
                movePlaneLeftRight(isRight: true)
                object.alpha = 0.8
            }
            
            if object.name == "pause_btn" {
                showPausedView()
                isPaused = true
            }
        }
    }
    
    private func movePlaneUpDown(isDown: Bool) {
        if isDown {
            plane.run(SKAction.move(to: CGPoint(x: plane.position.x, y: plane.position.y - 10), duration: 0.2)) {
                self.movePlaneUpDown(isDown: true)
            }
        } else {
            plane.run(SKAction.move(to: CGPoint(x: plane.position.x, y: plane.position.y + 10), duration: 0.2)) {
                self.movePlaneUpDown(isDown: false)
            }
        }
    }
    
    private func movePlaneLeftRight(isRight: Bool) {
        if isRight {
            if plane.position.x < size.width / 2 {
                plane.run(SKAction.move(to: CGPoint(x: plane.position.x + 10, y: plane.position.y), duration: 0.2)) {
                    self.movePlaneLeftRight(isRight: true)
                }
            }
        } else {
            if plane.position.x > 0 {
                plane.run(SKAction.move(to: CGPoint(x: plane.position.x - 10, y: plane.position.y), duration: 0.2)) {
                    self.movePlaneLeftRight(isRight: false)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch != nil {
            let loc = touch!.location(in: self)
            let object = atPoint(loc)
            
            if object.name == "jostik_up" {
                object.alpha = 1
                plane.removeAllActions()
            }
            
            if object.name == "jostik_bottom" {
                object.alpha = 1
                plane.removeAllActions()
            }
            
            if object.name == "jostik_left" {
                object.alpha = 1
                plane.removeAllActions()
            }
            
            if object.name == "jostik_right" {
                object.alpha = 1
                plane.removeAllActions()
            }
        }
    }
    
    private var pauseNode: PauseNode?
    private var winNode: WinNode?
    private var loseNode: LoseNode?
    
    private func showPausedView() {
        if pauseNode == nil {
            pauseNode = PauseNode(size: size, continueAction: {
                self.isPaused = false
                self.pauseNode?.removeFromParent()
            })
            pauseNode?.zPosition = 10
        }
        addChild(pauseNode!)
    }
    
    private func showWinView() {
        if winNode == nil {
            winNode = WinNode(size: size)
            winNode?.zPosition = 10
        }
        addChild(winNode!)
        isPaused = true
    }
    
    private func showLoseView() {
        if loseNode == nil {
            loseNode = LoseNode(size: size)
            loseNode?.zPosition = 10
        }
        addChild(loseNode!)
        isPaused = true
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: CirclerGameScene(level: 6))
            .ignoresSafeArea()
    }
}
