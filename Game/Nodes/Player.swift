//
//  Player.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 31/10/2022.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    private var doubleJumpUsed: Bool = false
    private var playerInAir: Bool = false {
        didSet {
            if playerInAir == false {
                doubleJumpUsed = false
            }
        }
    }
    
    init(position: CGPoint, zPosition: CGFloat, collisionBitmask: UInt32, contactTestBitmask: UInt32) {
        let texture = SKTexture(imageNamed: "playerCharacter")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.zPosition = zPosition
        self.name = "player"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.contactTestBitMask = contactTestBitmask
        self.physicsBody?.collisionBitMask = collisionBitmask
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0.6
        self.physicsBody?.mass = 10
        self.physicsBody?.restitution = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromParent() {
        super.removeFromParent()
    }
    
    func moveLeft() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: -50, dy: velocity.dy)
    }
    
    func moveRight() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: 50, dy: velocity.dy)
    }
    
    private func shootBullet() {
        guard let parent = self.parent else { return } //make sure player has a parent (normally GameScene)
        let bullet = SKShapeNode(circleOfRadius: 4.0)
        bullet.fillColor = UIColor.red
        bullet.position = self.position //Set bullet position to the player position
        bullet.zPosition = 0
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
        bullet.physicsBody?.velocity = CGVector(dx: 200, dy: 0) //Giving initial velocity
        bullet.physicsBody?.collisionBitMask = 1
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.affectedByGravity = false //Bullet not falling
        bullet.physicsBody?.linearDamping = 0 //Stops the bullet from stopping mid air
        bullet.name = "bullet"
        
        parent.addChild(bullet)
    }
}
