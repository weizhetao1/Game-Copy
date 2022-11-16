//
//  Enemy.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 11/10/2022.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    private var health: Int {
        didSet {
            if health <= 0 {
                self.removeFromParent()
            }
        }
    }
    
    init(imageNamed: String, position: CGPoint, zPosition: CGFloat, name: String,
         collisionBitmask: UInt32, contactTestBitmask: UInt32, health: Int) {
        self.health = health
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.zPosition = zPosition
        self.name = name
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.contactTestBitMask = contactTestBitmask
        self.physicsBody?.collisionBitMask = collisionBitmask
        self.physicsBody?.allowsRotation = false
    }
    
    override func removeFromParent() {
        super.removeFromParent()
    }
    
    func takeDamage(of damage: Int) {
        health -= damage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

