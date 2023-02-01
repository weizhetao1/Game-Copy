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
    
    private let swingTime: CGFloat = MeleeWeaponStats.swingTime
    var facing: PlayerFacing = .right {
        didSet {
            switch facing {
            case .right:
                self.xScale = abs(self.xScale)
                self.attackRotate = SKAction.rotate(byAngle: -CGFloat.pi / 2, duration: MeleeWeaponStats.swingTime)
            case .left:
                self.xScale = -abs(self.xScale)
                self.attackRotate = SKAction.rotate(byAngle: CGFloat.pi / 2, duration: MeleeWeaponStats.swingTime)
            }
        }
    }
    //The following are actions used when attacking, initialised here so they can be reused
    private var attackRotate = SKAction.rotate(byAngle: -CGFloat.pi / 2, duration: MeleeWeaponStats.swingTime)
    private let attackWait = SKAction.wait(forDuration: MeleeWeaponStats.swingTime / 3)
    private var reverseAttack = SKAction.rotate(toAngle: CGFloat.zero, duration: MeleeWeaponStats.swingTime / 5, shortestUnitArc: true)
    
    init() {
        let texture = SKTexture(imageNamed: "Sword") //load texture
        super.init(texture: texture, color: .clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size()) //physics body based on the sword
        self.physicsBody?.categoryBitMask = PhysicsCategory.sword
        self.physicsBody?.contactTestBitMask = 0 //doesn't contact initially
        self.physicsBody?.collisionBitMask = 0 //doesn't collide
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true //pinned to the player
        self.physicsBody?.angularDamping = 0 //no angular damping
        self.physicsBody?.allowsRotation = false //no rotation to start with
        self.scale(to: CGSize(width: MeleeWeaponStats.size, height: MeleeWeaponStats.size)) //scale to appropriate size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attack() {
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy //contact test with enemy during attack
        self.physicsBody?.allowsRotation = true //allows to rotate when attacking
        self.run(attackRotate) {
            self.physicsBody?.contactTestBitMask = 0 //stops testing with enemy as attack has stopped
            self.run(SKAction.sequence([self.attackWait, self.reverseAttack])) { //wait then reverse the attack
                self.physicsBody?.angularVelocity = 0 //stops any angular velocity
                self.physicsBody?.allowsRotation = false //stops rotating
            }
        }
    }
    
}
