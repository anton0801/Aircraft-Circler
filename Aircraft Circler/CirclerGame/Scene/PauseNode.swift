import SpriteKit

class PauseNode: SKSpriteNode {
    
    var continueAction: () -> Void
    
    init(size: CGSize, continueAction: @escaping () -> Void) {
        self.continueAction = continueAction
        
        let backgroundBlack = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: size)
        backgroundBlack.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundBlack.zPosition = -1
        
        let pauseTitle = SKSpriteNode(imageNamed: "pause_title")
        pauseTitle.position = CGPoint(x: size.width / 2, y: size.height - 100)
        
        let pauseContent = SKSpriteNode(imageNamed: "paused_content")
        pauseContent.position = CGPoint(x: size.width / 2, y: size.height / 2)
        pauseContent.size = CGSize(width: 450, height: 400)
        
        let continuePlayBtn = SKSpriteNode(imageNamed: "continue_play")
        continuePlayBtn.size = CGSize(width: 102, height: 100)
        continuePlayBtn.position = CGPoint(x: size.width / 2, y: 100)
        continuePlayBtn.name = "continue_play"
        
        super.init(texture: nil, color: .clear, size: size)
        
        addChild(backgroundBlack)
        addChild(pauseTitle)
        addChild(pauseContent)
        addChild(continuePlayBtn)
        
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
                continueAction()
            }
        }
    }
    
}
