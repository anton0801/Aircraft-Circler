import SpriteKit

class LoseNode: SKSpriteNode {
    
    init(size: CGSize) {
        let backgroundBlack = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: size)
        backgroundBlack.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundBlack.zPosition = -1
        
        let loseTitle = SKSpriteNode(imageNamed: "lose_title")
        loseTitle.position = CGPoint(x: size.width / 2, y: size.height - 100)
        
        let loseContent = SKSpriteNode(imageNamed: "lose_content")
        loseContent.position = CGPoint(x: size.width / 2, y: size.height / 2)
        loseContent.size = CGSize(width: 450, height: 400)
        
        let continuePlayBtn = SKSpriteNode(imageNamed: "continue_play")
        continuePlayBtn.size = CGSize(width: 102, height: 100)
        continuePlayBtn.position = CGPoint(x: size.width / 2 + 75, y: 100)
        continuePlayBtn.name = "continue_play"
        
        let restartBtn = SKSpriteNode(imageNamed: "restart_btn")
        restartBtn.size = CGSize(width: 102, height: 100)
        restartBtn.position = CGPoint(x: size.width / 2 - 75, y: 100)
        restartBtn.name = "restart_btn"
        
        super.init(texture: nil, color: .clear, size: size)
        
        addChild(backgroundBlack)
        addChild(loseTitle)
        addChild(loseContent)
        addChild(continuePlayBtn)
        addChild(restartBtn)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let object = atPoint(loc)
            
            if object.name == "continue_play" {
                NotificationCenter.default.post(name: Notification.Name("to_map"), object: nil)
            }
            if object.name == "restart_btn" {
                NotificationCenter.default.post(name: Notification.Name("restart"), object: nil)
            }
        }
    }
    
}
