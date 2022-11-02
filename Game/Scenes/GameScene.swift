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
    
    private var player: Player!
    private var leftTouched: Bool = false
    private var rightTouched: Bool = false
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpPlayer()
        setUpEnemy()
        setUpBackground()
        setUpBoundaries()
        setUpFireButton()
        setUpMoveButtons()
        setUpJumpButton()
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
        player = Player(position: CGPoint(x: size.width * 0.25, y: size.height * 0.5), zPosition: 1,
                        collisionBitmask: 1, contactTestBitmask: 2)
        
        addChild(player)
    }
    
    private func setUpEnemy() {
        for i in 0...5 {
            let enemy = Enemy(imageNamed: "Stickman", position: CGPoint(x: size.width * 0.5+0.05*CGFloat(i), y: size.height * 0.5),
                              zPosition: 0, name: "enemy", collisionBitmask: 1, contactTestBitmask: 1, health: 100)
            enemy.scale(to: CGSize(width: 40, height: 40))
            addChild(enemy)
        }
    }
    
    private func setUpBoundaries() {
        let ground = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.25, width: size.width, height: 3))
        ground.fillColor = UIColor.white
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: size.height * 0.25, width: size.width, height: CGFloat(3)))
        ground.physicsBody?.isDynamic = false //The ground will not move.
        ground.physicsBody?.collisionBitMask = 1
        ground.physicsBody?.friction = 0.2
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.contactTestBitMask = 2
        ground.name = "ground"
        
        addChild(ground)
    }
    
    private func setUpFireButton() {
        let button = ButtonNode(position: CGPoint(x: size.width * 0.85, y: size.width * 0.15), zPosition: 20, name: "fireButton", action: player.shootBullet)
        addChild(button)
    }
    
    private func setUpMoveButtons() {
        let buttonLeft = ButtonNode(position: CGPoint(x: size.width * 0.13, y: size.width * 0.15), zPosition: 21, name: "leftButton",
                                    action: { self.leftTouched = true },
                                    endAction: { self.leftTouched = false })
        let buttonRight = ButtonNode(position: CGPoint(x: size.width * 0.20, y: size.width * 0.15), zPosition: 21, name: "rightButton",
                                     action: { self.rightTouched = true },
                                     endAction: { self.rightTouched = false })
        addChild(buttonLeft)
        addChild(buttonRight)
    }
    
    private func setUpJumpButton() {
        let jumpButton = ButtonNode(position: CGPoint(x: size.width * 0.78, y: size.width * 0.17), zPosition: 22, name: "jumpButton", action: player.jump)
        addChild(jumpButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        if leftTouched && rightTouched {
            return //do nothing if both right and left are touched
        } else if leftTouched {
            player.moveLeft()
        } else if rightTouched {
            player.moveRight()
        }
        
        /*
        if let velocity = player.physicsBody?.velocity {
            if velocity.dx > 50 {
                player.physicsBody?.velocity = CGVector(dx: 50, dy: velocity.dy)
            } else if velocity.dx < -50 {
                player.physicsBody?.velocity = CGVector(dx: -50, dy: velocity.dy)
            }
        }*/
    }
    
    private func destroy(node: SKNode?) {
        node?.removeFromParent()
    }
    
    private func inContact(contact: SKPhysicsContact, _ name1: String, _ name2: String) -> Bool {
        if (contact.bodyA.node?.name == name1 && contact.bodyB.node?.name == name2) || (contact.bodyA.node?.name == name2 && contact.bodyB.node?.name == name1) {
            return true
        }
        return false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return } //make sure 2 nodes exist for the contact
        if inContact(contact: contact, "bullet", "enemy") {
            self.enumerateChildNodes(withName: "enemy") {
                node, _ in //Iterates through list of enemies
                if let enemy = node as? Enemy { //make sure that they are of type Enemy
                    if nodeA.isEqual(to: enemy) || nodeB.isEqual(to: enemy) {
                        enemy.takeDamage(of: 10) //let enemy take damage if involved in the collision
                        return
                    }
                }
            }
            if nodeA.name == "bullet" {
                destroy(node: nodeA)
            } else if nodeB.name == "bullet" {
                destroy(node: nodeB)
            }
        } else if inContact(contact: contact, "player", "ground") {
            player.inAir = false
        }
    }
}

