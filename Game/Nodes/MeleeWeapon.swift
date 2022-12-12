//
//  MeleeWeapon.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 12/12/2022.
//

import Foundation
import SpriteKit

enum MeleeWeaponType {
    case player, enemy
}

class MeleeWeapon: SKSpriteNode {
    
    //The following are actions used when attacking, initialised here so they can be reused
    private let attackRotate = SKAction.rotate(byAngle: -CGFloat.pi / 2, duration: 0.2)
    private let attackWait = SKAction.wait(forDuration: 0.1)
    private let reverseAttack = SKAction.rotate(byAngle: CGFloat.pi / 2, duration: 0.03)
    
    init() {
        let texture = SKTexture(imageNamed: "Sword") //load texture
        super.init(texture: texture, color: .clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size()) //physics body based on the sword
        self.anchorPoint = CGPoint(x: 0, y: 0) //set anchorpoint on bottom left
        self.physicsBody?.categoryBitMask = PhysicsCategory.sword
        self.physicsBody?.contactTestBitMask = 0 //doesn't contact initially
        self.physicsBody?.collisionBitMask = 0 //doesn't collide
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true //pinned to the player
        self.scale(to: CGSize(width: 2000, height: 2000)) //scale to appropriate size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attack() {
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy //contact test with enemy during attack
        self.run(attackRotate) {
            self.physicsBody?.contactTestBitMask = 0 //stops testing with enemy as attack has stopped
            self.run(SKAction.sequence([self.attackWait, self.reverseAttack])) //wait then reverse the attack
        }
    }
    
}
