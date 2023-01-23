//
//  Player.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 31/10/2022.
//

import Foundation
import SpriteKit

enum PlayerFacing: Int {
    case left, right
}

class Player: SKSpriteNode {
    
    var health: CGFloat = 100 {
        didSet {
            if health <= 0 {
                health = 0 //doesn't drop below 0
            } else if health > maxHealth {
                health = maxHealth //limit to max health
            }
            healthBar?.update()
        }
    }
    var maxHealth: CGFloat = 150
    var facing: PlayerFacing = .right {
        didSet {
            switch facing {
            case .right:
                self.meleeWeapon?.facing = .right
            case .left:
                self.meleeWeapon?.facing = .left
            }
        }
    }
    private var horizontalMoveSpeed: CGFloat = PlayerBaseStats.horizontalMoveSpeed
    var speedFactor: CGFloat = 1 {
        didSet {
            self.horizontalMoveSpeed = PlayerBaseStats.horizontalMoveSpeed * speedFactor
            self.bulletSpeed = PlayerBaseStats.bulletSpeed * speedFactor
        }
    }
    private var bulletSpeed: CGFloat = PlayerBaseStats.bulletSpeed
    private var doubleJumpUsed: Bool = false
    private var jumpImpulse: CGFloat = 8000
    var inAir: Bool = false {
        didSet {
            if inAir == false {
                doubleJumpUsed = false
            }
        }
    }
    private var meleeWeapon: MeleeWeapon?
    weak var healthBar: HealthBar?
    
    init(position: CGPoint, zPosition: CGFloat) {
        let texture = SKTexture(imageNamed: "Stickman")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.zPosition = zPosition
        self.name = "player"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.ground //combines categories
        self.physicsBody?.collisionBitMask = PhysicsCategory.platform | PhysicsCategory.wall | PhysicsCategory.enemy | PhysicsCategory.ground
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = PlayerBaseStats.friction
        self.physicsBody?.mass = 10
        self.physicsBody?.restitution = 0
        self.physicsBody?.allowsRotation = false
        self.scale(to: CGSize(width: 128, height: 128))
        attachMeleeWeapon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attachMeleeWeapon() {
        let sword = MeleeWeapon()
        self.meleeWeapon = sword
        self.addChild(sword)
    }
    
    func moveLeft() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: -horizontalMoveSpeed, dy: velocity.dy) //doesn't change vertical speed
        facing = .left
    }
    
    func moveRight() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: horizontalMoveSpeed, dy: velocity.dy) //doesn't change vertical speed
        facing = .right
    }
    
    func stopHorizontalMovement() {
        guard let velocity = self.physicsBody?.velocity else { return }
        let direction = sign(velocity.dx) //get sign of current horizontal velocity
        print(direction) //testing purposes
        self.physicsBody?.velocity = CGVector(dx: direction * PlayerBaseStats.horizontalMoveSpeed, dy: velocity.dy) //stop gradually by setting velocity to base stat
    }
    
    func jump() {
        if doubleJumpUsed == false {
            guard let velocity = self.physicsBody?.velocity else { return }
            self.physicsBody?.velocity = CGVector(dx: velocity.dx, dy: PlayerBaseStats.jumpSpeed) //keep horizontal speed the same
        }
        if inAir == true {
            doubleJumpUsed = true
        } else {
            inAir = true
        }
    }
    
    func gainHealth(of gain: CGFloat) {
        self.health += gain
    }

    func takeDamage(of damage: CGFloat) {
        self.health -= damage
    }
    
    func shootBullet() {
        guard let scene = self.scene else { return } //make sure player has a scene (normally GameScene)
        let closestEnemy = findClosestEnemy()
        let bullet = Bullet(position: self.position, towards: closestEnemy, speed: self.bulletSpeed, targetTestBitMask: PhysicsCategory.enemy)
        
        scene.addChild(bullet)
    }
    
    func meleeAttack() {
        guard let meleeWeapon = meleeWeapon else { return }
        meleeWeapon.attack()
    }
    
    private func findClosestEnemy() -> SKNode? {
        guard let parent = self.parent else { return nil } //return if player doesn't have a parent
        var closestNode: SKNode? //might not be one, so optional
        var closestDistance = CGFloat.infinity
        parent.enumerateChildNodes(withName: "enemy") {
            node, _ in
            let distance = node.distanceTo(node: self)
            if distance < closestDistance {
                closestNode = node
                closestDistance = distance //finding closest enemy node
            }
        }
        return closestNode
    }
    
}
