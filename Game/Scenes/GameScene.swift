//
//  GameScene.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 14/09/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: SKSpriteNode!
    private var enemy: SKSpriteNode!
    private var enemyHealth: Int = 100
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpPlayer()
        setUpEnemy()
        setUpBackground()
        setUpBoundaries()
        setUpFireButton()
        setUpMoveButtons()
    }
    
    private func setUpBackground() {
        backgroundColor = UIColor.cyan
    }
    
    private func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
        physicsWorld.contactDelegate = self //informs the class itself upon contacts
    }
    
    private func setUpPlayer() {
        player = SKSpriteNode(imageNamed: "Stickman")
        player.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
        player.zPosition = 0
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.friction = 0
        player.scale(to: CGSize(width: 50, height: 50))
        player.name = "player"
        
        addChild(player)
    }
    
    private func setUpEnemy() {
        enemy = SKSpriteNode(imageNamed: "Stickman")
        enemy.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
        enemy.zPosition = 0
        enemy.physicsBody?.contactTestBitMask = 1
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.height / 2)
        enemy.physicsBody?.collisionBitMask = 1
        enemy.scale(to: CGSize(width: 50, height: 50))
        enemy.name = "enemy"
        
        addChild(enemy)
    }
    
    private func setUpBoundaries() {
        let ground = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.25, width: size.width, height: 3))
        ground.fillColor = UIColor.white
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: size.height * 0.25, width: size.width, height: CGFloat(3)))
        ground.physicsBody?.isDynamic = false //The ground will not move.
        ground.physicsBody?.collisionBitMask = 1
        ground.physicsBody?.friction = 0
        
        addChild(ground)
    }
    
    private func setUpFireButton() {
        let button = ButtonNode.button(position: CGPoint(x: size.width * 0.85, y: size.width * 0.15), zPosition: 20, name: "fireButton")
        
        addChild(button)
    }
    
    private func setUpMoveButtons() {
        let buttonLeft = ButtonNode.button(position: CGPoint(x: size.width * 0.13, y: size.width * 0.15), zPosition: 21, name: "leftButton")
        let buttonRight = ButtonNode.button(position: CGPoint(x: size.width * 0.20, y: size.width * 0.15), zPosition: 21, name: "rightButton")
        
        addChild(buttonLeft)
        addChild(buttonRight)
    }
    
    private func shootBullet(position: CGPoint) {
        let bullet = SKShapeNode(circleOfRadius: 4.0)
        bullet.fillColor = UIColor.red
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
        bullet.physicsBody?.velocity = CGVector(dx: 200, dy: 0) //Giving initial velocity
        bullet.position = position //Set bullet position to the argument
        bullet.zPosition = 0
        bullet.physicsBody?.collisionBitMask = 1
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.affectedByGravity = false //Bullet not falling
        bullet.physicsBody?.linearDamping = 0 //Stops the bullet from stopping
        bullet.name = "bullet"
        
        addChild(bullet)
    }
    
    private func playerMoveLeft() {
        player.physicsBody?.velocity = CGVector(dx: -50, dy: 0)
    }
    
    private func playerMoveRight() {
        player.physicsBody?.velocity = CGVector(dx: 50, dy: 0)
    }
    
    private func playerStopsMoving() {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "fireButton" {
                shootBullet(position: player.position)
            } else if touchedNode.name == "leftButton" {
                playerMoveLeft()
            } else if touchedNode.name == "rightButton" {
                playerMoveRight()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "leftButton" {
                playerMoveLeft()
            } else if touchedNode.name == "rightButton" {
                playerMoveRight()
            } else {
                playerStopsMoving() //Stops character moving if touch has moved outside of buttons
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "leftButton" {
                playerStopsMoving()
            } else if touchedNode.name == "rightButton" {
                playerStopsMoving()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    private func destroy(node: SKNode?) {
        node?.removeFromParent()
        
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bullet") || (contact.bodyA.node?.name == "bullet" && contact.bodyB.node?.name == "enemy") {
            enemyHealth -= 10
            if contact.bodyA.node?.name == "bullet" {
                destroy(node: contact.bodyA.node)
            } else if contact.bodyB.node?.name == "bullet" {
                destroy(node: contact.bodyB.node)
            }
            if enemyHealth <= 0 {
                destroy(node: enemy)
            }
        }
    }
}

