//
//  Player.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 31/10/2022.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var health: CGFloat = 100 {
        didSet {
            if health <= 0 {
                health = 0 //doesn't drop below 0
            } else if health > maxHealth {
                health = maxHealth //limit to max health
            }
        }
    }
    var maxHealth: CGFloat = 150
    private var doubleJumpUsed: Bool = false
    private var horizontalSpeed: CGFloat = 150
    private var jumpImpulse: CGFloat = 8000
    var inAir: Bool = false {
        didSet {
            if inAir == false {
                doubleJumpUsed = false
            }
        }
    }
    
    init(position: CGPoint, zPosition: CGFloat, collisionBitmask: UInt32, contactTestBitmask: UInt32) {
        let texture = SKTexture(imageNamed: "Stickman")
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
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.allowsRotation = false
        self.scale(to: CGSize(width: 128, height: 128))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveLeft() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: -horizontalSpeed, dy: velocity.dy)
    }
    
    func moveRight() {
        guard let velocity = self.physicsBody?.velocity else { return }
        self.physicsBody?.velocity = CGVector(dx: horizontalSpeed, dy: velocity.dy)
    }
    
    func jump() {
        if doubleJumpUsed == false {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
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
    
    func gainHealth() {
        self.health += 21
    }
    
    func takeDamage(of damage: CGFloat) {
        self.health -= damage
    }
    
    func takeDamage() {
        self.health -= 29
    }
    
    func shootBullet() {
        guard let scene = self.scene else { return } //make sure player has a scene (normally GameScene)
        let closestEnemy = findClosestEnemy()
        let bullet = Bullet(position: self.position, towards: closestEnemy, speed: 200)
        
        scene.addChild(bullet)
    }
    
    private func findClosestEnemy() -> SKNode? {
        guard let parent = self.parent else { return nil } //return if player doesn't have a parent
        var closestNode: SKNode? //might not be one so optional
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
