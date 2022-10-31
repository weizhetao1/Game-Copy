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
        self.physicsBody?.applyImpulse(CGVector(dx: -500, dy: 0))
    }
    
    func moveRight() {
        self.physicsBody?.applyImpulse(CGVector(dx: 500, dy: 0))
    }
}
