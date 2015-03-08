import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let colors = [ UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.purpleColor() ]
    
    var bins: [SKShapeNode] = []
    var ball: SKShapeNode! = nil
    
    var score = 0
    let scoreText = SKLabelNode()
    
    var level = 1
    let levelText = SKLabelNode()
    
    var touch = 0
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self // Allows this class to listen for node contacts.
        
        backgroundColor = UIColor.brownColor()
        
        for i in 0...3 {
            let bin = SKShapeNode(rectOfSize: CGSize(width: 125, height: 75))
            bin.name = "bin\(i)"
            bin.position = CGPoint(x: CGRectGetMaxX(self.frame) / 4 * CGFloat(i) + 128, y: 125)
            bin.fillColor = colors[i]
            
            // Allows the bin to fire events when it is hit.
            let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 125, height: 75))
            body.affectedByGravity = false
            body.allowsRotation = false
            body.categoryBitMask = 0
            body.contactTestBitMask = 1
            bin.physicsBody = body
            
            self.addChild(bin)
            bins.append(bin)
        }
        
        scoreText.text = "Score: 0"
        scoreText.fontSize = 36
        scoreText.position = CGPoint(x: CGRectGetMaxX(self.frame) - 80, y: CGRectGetMaxY(self.frame) - 130)
        self.addChild(scoreText)
        
        levelText.text = "Level: 1"
        levelText.fontSize = 36
        levelText.position = CGPoint(x: CGRectGetMinX(self.frame) + 70, y: CGRectGetMaxY(self.frame) - 130)
        self.addChild(levelText)
        
        startRound()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let b = ball {
            for t in touches {
                touch = t.locationInNode(self).x < CGRectGetMidX(self.frame) ? -10 : 10
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        touch = 0
    }
   
    override func update(currentTime: CFTimeInterval) {
        if let b = ball {
            b.position.x += CGFloat(touch)
            b.position.y -= CGRectGetMaxY(self.frame) / 250 + (CGFloat(level) - 1)
            
            if b.position.y < CGRectGetMinY(self.frame) {
                startRound()
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.node? as SKShapeNode).fillColor == ball.fillColor {
            score++
            scoreText.text = "Score: \(score)"
        }
        
        startRound()
    }
    
    func startRound() {
        if let b = ball {
            self.removeChildrenInArray([ ball ])
            ball = nil
        }
        
        if score % 5 == 0 { // If score is not 0 and it can be divided evenly by 5 (5, 10, 15, 20...)
            level = score / 5 + 1
            levelText.text = "Level: \(level)"
        }
        
        ball = SKShapeNode(circleOfRadius: 30)
        ball.fillColor = colors[random() % colors.count] // Sets the fill color to a random color in our array.
        ball.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame))
        
        // Allows the ball to fire events when it is hit.
        let body = SKPhysicsBody(circleOfRadius: 30)
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = 1
        body.contactTestBitMask = 0
        ball.physicsBody = body
        
        self.addChild(ball)
    }
}
