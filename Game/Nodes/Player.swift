//
//  Player.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 31/10/2022.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var health: CGFloat = 100
    var maxHealth: CGFloat = 150
    private var doubleJumpUsed: Bool = false
    private var horizontalSpeed: CGFloat = 150
    private var jumpImpulse: CGFloat = 10000
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
    
    override func removeFromParent() {
        super.removeFromParent()
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
        self.health += 9
    }
    
    func takeDamage(of damage: CGFloat) {
        self.health -= damage
    }
    
    func takeDamage() {
        self.health -= 11
    }
    
    func shootBullet() {
        guard let parent = self.parent else { return } //make sure player has a parent (normally GameScene)
        let bullet = SKShapeNode(circleOfRadius: 4.0)
        bullet.fillColor = UIColor.red
        bullet.position = CGPoint(x: self.position.x, y: self.position.y) //Set bullet position to the player position
        bullet.zPosition = 0
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
        bullet.physicsBody?.velocity = velocityTowards(node: findClosestEnemy(), speed: 200) //Giving initial velocity
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.affectedByGravity = false //Bullet not falling
        bullet.physicsBody?.linearDamping = 0 //Stops the bullet from stopping mid air
        bullet.name = "bullet"
        
        parent.addChild(bullet)
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
    
    private func velocityTowards(node: SKNode?, speed: CGFloat) -> CGVector {
        guard let node = node else {
            return CGVector(dx: speed, dy: 0) //A default velocity if there is no closest enemy
        }
        let timeNeeded = self.distanceTo(node: node) / speed
        return CGVector(dx: (node.position.x - self.position.x) / timeNeeded, dy: (node.position.y - self.position.y) / timeNeeded)
    }
}
