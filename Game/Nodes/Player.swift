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
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.contactTestBitMask = contactTestBitmask
        self.physicsBody?.collisionBitMask = collisionBitmask
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0.6
        self.physicsBody?.mass = 10
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = 1
        self.scale(to: CGSize(width: 50, height: 50))
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
    
    func jump() {
        if doubleJumpUsed == false {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5000))
        }
        if inAir == true {
            doubleJumpUsed = true
        } else {
            inAir = true
        }
    }
    
    func shootBullet() {
        guard let parent = self.parent else { return } //make sure player has a parent (normally GameScene)
        let bullet = SKShapeNode(circleOfRadius: 4.0)
        bullet.fillColor = UIColor.red
        bullet.position = CGPoint(x: self.position.x, y: self.position.y) //Set bullet position to the player position
        bullet.zPosition = 0
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
        bullet.physicsBody?.velocity = velocityTowards(node: findClosestEnemy(), speed: 200) //Giving initial velocity
        bullet.physicsBody?.collisionBitMask = 2
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.affectedByGravity = false //Bullet not falling
        bullet.physicsBody?.linearDamping = 0 //Stops the bullet from stopping mid air
        bullet.name = "bullet"
        
        parent.addChild(bullet)
    }
    
    private func findClosestEnemy() -> SKNode? {
        guard let parent = self.parent else { return nil }
        var closestNode: SKNode?
        var closestDistance = CGFloat.infinity
        parent.enumerateChildNodes(withName: "enemy") {
            node, _ in
            let distance = node.distanceTo(node: self)
            if distance < closestDistance {
                closestNode = node
                closestDistance = distance
            }
        }
        return closestNode
    }
    
    private func velocityTowards(node: SKNode?, speed: CGFloat) -> CGVector {
        let timeNeeded = self.distanceTo(node: node) / speed
        return CGVector(dx: (node.position.x - self.position.x) / timeNeeded, dy: (node.position.y - self.position.y) / timeNeeded)
    }
}
