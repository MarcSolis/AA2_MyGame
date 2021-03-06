//
//  GameScene.swift
//  AA2_MyGame
//
//  Created by Alumne on 23/3/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var enemy1 : SKSpriteNode!
    
    enum PlayerState {
        case WALK, ATTACK, IDLE
    }
    
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
    private let idleAnimation = [
        SKTexture(imageNamed: "Idle (1)"),
        SKTexture(imageNamed: "Idle (2)"),
        SKTexture(imageNamed: "Idle (3)"),
        SKTexture(imageNamed: "Idle (4)"),
        SKTexture(imageNamed: "Idle (5)"),
        SKTexture(imageNamed: "Idle (6)"),
        SKTexture(imageNamed: "Idle (7)"),
        SKTexture(imageNamed: "Idle (8)"),
        SKTexture(imageNamed: "Idle (9)"),
        SKTexture(imageNamed: "Idle (10)")
    ]
    
    private var attackAction : SKAction!
    private var walkAction : SKAction!
    private var idleAction : SKAction!
    private var movementActionStart : SKAction!
    private var smokeParticles : SKEmitterNode!
    private var playerState : PlayerState = PlayerState.IDLE
    
    let attackActionKey = "Attack"
    let walkActionKey = "Walk"
    let idleActionKey = "Idle"
    let movementActionStartKey = "movementStart"
    
    
    private let motionManager = CMMotionManager()
    
    var desiredPosition : CGPoint = CGPoint(x: -100, y: -100)
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        playerState = PlayerState.IDLE
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.08
        self.enemy1 = SKSpriteNode(imageNamed: "ovni")
        self.enemy1.size = CGSize(width: w/2, height: w/2)
        self.enemy1.position = CGPoint(x: 200, y: -Int.random(in: 80 ... 120))
        self.enemy1.zPosition = 1000
        self.enemy1.physicsBody = SKPhysicsBody(texture: enemy1.texture!, size: enemy1.size)
        self.enemy1.physicsBody?.affectedByGravity = false
        self.enemy1.physicsBody?.velocity = CGVector(dx: -100, dy: 0)

        self.enemy1.name = "enemy1"
        self.enemy1.physicsBody!.collisionBitMask = 0x00000001
        self.addChild(self.enemy1)
        
        
        self.knight = SKSpriteNode(imageNamed: "Idle (1)")
        self.knight.size = CGSize(width: w, height: w)
        
        //Physics
        self.knight.physicsBody = SKPhysicsBody(texture: knight.texture!, size: knight.size)
        self.knight.physicsBody?.affectedByGravity = false
        self.knight.name = "knight"
        self.knight.physicsBody!.collisionBitMask = 0x00000000
        self.knight.physicsBody!.contactTestBitMask = 0x00000001
        

        
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: self.walkAnimation, timePerFrame: 0.07))
        self.idleAction = SKAction.repeatForever(SKAction.animate(with: self.idleAnimation, timePerFrame: 0.15))
        self.attackAction = SKAction.animate(with: self.attackAnimation, timePerFrame: 0.15)
        
        //self.knight.run(self.walkAction, withKey: walkActionKey)
        self.knight.position = CGPoint(x: -100, y: -100)
        self.knight.zPosition = 1000
        self.addChild(self.knight)
        
        self.smokeParticles = SKEmitterNode(fileNamed: "Smoke")
        self.smokeParticles.position.x = -10
        self.smokeParticles.position.y = -60
        self.smokeParticles.zPosition = -1
        
        self.knight.addChild( self.smokeParticles)
        
        motionManager.startAccelerometerUpdates()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name == "knight"){
            contact.bodyB.node!.removeFromParent()
        }
        else if(contact.bodyB.node?.name == "knight"){
            contact.bodyA.node!.removeFromParent()
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //self.knight.position.x = touch.location(in: self).x
            self.knight.run(self.attackAction)
            //let destination = CGPoint(x: touch.location(in: self).x, y: self.knight.position.y)
            //self.movementActionStart = SKAction.move(to: destination, duration: 1)
            //self.movementActionStart.timingMode = .easeInEaseOut
            //self.knight.run(self.movementActionStart, withKey: movementActionStartKey)
            //self.smokeParticles.run(self.movementActionStart, withKey: movementActionStartKey)
        }
        
        for t in touches {self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //self.knight.position.x = touch.location(in: self).x
            //let destination = CGPoint(x: touch.location(in: self).x, y: self.knight.position.y)
            //self.knight.removeAction(forKey: movementActionStartKey)
            //self.smokeParticles.removeAction(forKey: movementActionStartKey)
            
            //let moveToPoint = SKAction.move(to: destination, duration: 0.05)
            //moveToPoint.timingMode = .easeInEaseOut
            //self.knight.run(moveToPoint)
        }
        
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {}
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let offset : CGFloat = 1
        if let accelerometerData = self.motionManager.accelerometerData {
            let changeX = CGFloat(accelerometerData.acceleration.y) * 10
            if(changeX > offset){
                if(playerState == PlayerState.IDLE){
                    playerState = PlayerState.WALK
                    self.knight.removeAction(forKey: self.idleActionKey)
                    self.knight.run(self.walkAction, withKey: self.walkActionKey)
                    
                }
                self.knight.xScale = 1
                self.knight.position.x += changeX
            }
            else if(changeX < -offset){
                if(playerState == PlayerState.IDLE){
                    playerState = PlayerState.WALK
                    self.knight.removeAction(forKey: self.idleActionKey)
                    self.knight.run(self.walkAction, withKey: self.walkActionKey)
                    
                }
                self.knight.xScale = -1
                self.knight.position.x += changeX
            }
            else{
                if(playerState == PlayerState.WALK){
                    playerState = PlayerState.IDLE
                    self.knight.removeAction(forKey: self.walkActionKey)
                    self.knight.run(self.idleAction, withKey: self.idleActionKey)
                }
            }

        }
        
    }
}
