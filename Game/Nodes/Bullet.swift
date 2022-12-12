//
//  Bullet.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 23/11/2022.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    init(position: CGPoint, towards node: SKNode?, speed: CGFloat, targetTestBitMask: UInt32) {
        let texture = BulletTexture.bulletBlue
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.zPosition = 1
        self.scale(to: CGSize(width: 10, height: 10))
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.velocity = velocityTowards(node: node, speed: speed)
        self.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = 0 //doesn't collide with anything
        self.physicsBody?.contactTestBitMask = targetTestBitMask | PhysicsCategory.platform | PhysicsCategory.wall | PhysicsCategory.ground //set to the parameter, and it should disappear when hitting walls
        self.physicsBody?.affectedByGravity = false //Bullet not falling
        self.physicsBody?.linearDamping = 0 //Stops the bullet from stopping mid air
        self.name = "bullet"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func velocityTowards(node: SKNode?, speed: CGFloat) -> CGVector {
        guard let node = node else {
            return CGVector(dx: speed, dy: 0) //A default velocity if there is no closest enemy
        }
        let timeNeeded = self.distanceTo(node: node) / speed
        return CGVector(dx: (node.position.x - self.position.x) / timeNeeded, dy: (node.position.y - self.position.y) / timeNeeded)
    }
}
