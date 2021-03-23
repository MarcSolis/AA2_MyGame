//
//  GameScene.swift
//  AA2_MyGame
//
//  Created by Alumne on 23/3/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var knight : SKSpriteNode!
    private let walkAnimation = [
        SKTexture(imageNamed: "Run (1)"),
        SKTexture(imageNamed: "Run (2)"),
        SKTexture(imageNamed: "Run (3)"),
        SKTexture(imageNamed: "Run (4)"),
        SKTexture(imageNamed: "Run (5)"),
        SKTexture(imageNamed: "Run (6)"),
        SKTexture(imageNamed: "Run (7)"),
        SKTexture(imageNamed: "Run (8)"),
        SKTexture(imageNamed: "Run (9)"),
        SKTexture(imageNamed: "Run (10)")
    ]
    private let attackAnimation = [
        SKTexture(imageNamed: "Attack (1)"),
        SKTexture(imageNamed: "Attack (2)"),
        SKTexture(imageNamed: "Attack (3)"),
        SKTexture(imageNamed: "Attack (4)"),
        SKTexture(imageNamed: "Attack (5)"),
        SKTexture(imageNamed: "Attack (6)"),
        SKTexture(imageNamed: "Attack (7)"),
        SKTexture(imageNamed: "Attack (8)"),
        SKTexture(imageNamed: "Attack (9)"),
        SKTexture(imageNamed: "Attack (10)")
    ]
    
    private var attackAction : SKAction!
    private var walkAction : SKAction!
    
    let attackActionKey = "Attack"
    let walkActionKey = "Walk"
    var desiredPosition : CGPoint = CGPoint(x: -100, y: -100)
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.knight = SKSpriteNode(imageNamed: "Idle (1)")
        self.knight.size = CGSize(width: w, height: w)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: self.walkAnimation, timePerFrame: 0.07))
        self.attackAction = SKAction.repeatForever(SKAction.animate(with: self.attackAnimation, timePerFrame: 0.15))
        
        self.knight.run(self.walkAction, withKey: walkActionKey)
        self.knight.position = CGPoint(x: -100, y: -100)
        self.addChild(self.knight)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.knight.position.x = touch.location(in: self).x
            self.knight.removeAction(forKey: self.walkActionKey)
            self.knight.run(self.attackAction, withKey: self.attackActionKey)
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.knight.position.x = touch.location(in: self).x
        }
        
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.knight.position.x = touch.location(in: self).x
            self.knight.removeAction(forKey: self.attackActionKey)
            self.knight.run(self.walkAction, withKey: self.walkActionKey)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.knight.position.x = touch.location(in: self).x
            self.removeAction(forKey: self.attackActionKey)
            self.run(self.walkAction, withKey: self.walkActionKey)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
}
