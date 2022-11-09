//
//  GameScene.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 14/09/2022.
//

import Foundation
import SpriteKit
import GameplayKit

let tileSize = CGSize(width: 64, height: 64)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: Player! //There must be a player node, whether dead or alive
    private var map = SKTileMapNode(tileSet: SKTileSet(named: "Sample Grid Tile Set")!, columns: 24, rows: 8, tileSize: tileSize)
    private var cameraNode = SKCameraNode()
    private var leftTouched: Bool = false
    private var rightTouched: Bool = false
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpPlayer()
        setUpEnemy()
        setUpBackground()
        setUpMap()
        setUpButtons()
    }
    
    private func setUpBackground() {
        backgroundColor = UIColor.cyan
        cameraNode.position = CGPoint(x: size.width / 2 , y: size.width / 2)
        self.camera = cameraNode
        cameraNode.xScale = 4
        cameraNode.yScale = 4
        addChild(cameraNode)
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
            enemy.scale(to: CGSize(width: 92, height: 92))
            addChild(enemy)
        }
    }
    
    private func setUpMap() {
        /*
        guard let tileScene = SKScene(fileNamed: "Map1.sks"),
              let map = tileScene.childNode(withName: "Map1") as? SKTileMapNode else {
                  fatalError("Map1 not loaded")
              }
        map.removeFromParent()*/
        map.anchorPoint = CGPoint(x: 0, y: 0)
        
        let tileSet = SKTileSet(named: "Sample Grid Tile Set") //set a tile set
        let grassTiles = tileSet?.tileGroups.first { $0.name == "Grass" } //easier references to specific tiles
        let stoneTiles = tileSet?.tileGroups.first { $0.name == "Cobblestone" }
        for column in 0..<24 {
            map.setTileGroup(grassTiles, forColumn: column, row: 0) //paint the ground with grass
        }
        for row in 1..<8 {
            map.setTileGroup(stoneTiles, forColumn: 0, row: row)
            map.setTileGroup(stoneTiles, forColumn: 23, row: row) //adding walls
        }
        
        addChild(map)
        
        let ground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: map.mapSize.width, height: tileSize.height))
        ground.fillColor = UIColor.clear
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: map.mapSize.width, height: tileSize.height))
        ground.physicsBody?.isDynamic = false //The ground will not move.
        ground.physicsBody?.collisionBitMask = 1
        ground.physicsBody?.friction = 0.2
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.contactTestBitMask = 2
        ground.name = "ground"
        
        map.addChild(ground)
        
    }
    
    private func setUpButtons() {
        let fireButton = ButtonNode(position: CGPoint(x: size.width * 0.35, y: size.height * -0.25), zPosition: 20, name: "fireButton", action: player.shootBullet)
        let buttonLeft = ButtonNode(position: CGPoint(x: size.width * -0.37, y: size.height * -0.25), zPosition: 21, name: "leftButton",
                                    action: { self.leftTouched = true },
                                    endAction: { self.leftTouched = false })
        let buttonRight = ButtonNode(position: CGPoint(x: size.width * -0.29, y: size.height * -0.25), zPosition: 21, name: "rightButton",
                                     action: { self.rightTouched = true },
                                     endAction: { self.rightTouched = false })
        let jumpButton = ButtonNode(position: CGPoint(x: size.width * 0.28, y: size.height * -0.20), zPosition: 22, name: "jumpButton", action: player.jump)
        
        cameraNode.addChild(fireButton)
        cameraNode.addChild(jumpButton)
        cameraNode.addChild(buttonLeft)
        cameraNode.addChild(buttonRight)
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
        
        updateCameraPosition()
    }
    
    private func updateCameraPosition() {
        cameraNode.position = player.position //set camera position to player position
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

