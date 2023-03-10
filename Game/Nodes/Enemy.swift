//
//  Enemy.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 11/10/2022.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    private var health: CGFloat {
        didSet {
            if health <= 0 {
                if let scene = self.scene as? GameScene {
                    scene.enemiesLeft -= 1 //reduce number of enemies left
                }
                self.removeFromParent()
            }
        }
    }
    private var bulletSpeed: CGFloat = EnemyBaseStats.bulletSpeed
    
    init(imageNamed: String, position: CGPoint, zPosition: CGFloat, name: String, health: CGFloat) {
        self.health = health
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.zPosition = zPosition
        self.name = name
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = PhysicsCategory.platform | PhysicsCategory.wall | PhysicsCategory.player | PhysicsCategory.ground
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 1000
        self.scale(to: CGSize(width: EnemyBaseStats.size, height: EnemyBaseStats.size))
    }
    
    override func removeFromParent() {
        super.removeFromParent()
    }
    
    func takeDamage(of damage: CGFloat) {
        health -= damage
    }
    
    func shootBullet() {
        guard let scene = self.scene else { return } //make sure enemy has a scene (normally GameScene)
        guard let player = scene.childNode(withName: "player") else { return } //make sure there is a player in scene to shoot bullet at
        let bullet = Bullet(position: self.position, towards: player, speed: self.bulletSpeed, targetTestBitMask: PhysicsCategory.player)
        
        scene.addChild(bullet)
    }
    
    func update() {
        if Bool.randomTrue(probability: EnemyBaseStats.shootingChance) {
            self.shootBullet() //0.5% chance every frame to shoot a bullet
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

