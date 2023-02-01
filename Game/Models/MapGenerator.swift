//
//  MapGenerator.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 16/11/2022.
//

import Foundation
import SpriteKit

class MapGenerator {
    
    var tileMap: SKTileMapNode = SKTileMapNode()
    weak var scene: SKScene?
    
    func setUpTileMap(fileNamed fileName: String, scene: SKScene) {
        guard let tileScene = SKScene(fileNamed: fileName),
              let map = tileScene.childNode(withName: "Map1") as? SKTileMapNode else {
                  fatalError("Map1 not loaded")
              } //loading tile map node from the sks file and making sure it is a tile map
        map.removeFromParent()
        map.anchorPoint = CGPoint(x: 0, y: 0)
        tileMap = map
        self.scene = scene
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        for column in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileGroup = tileMap.tileGroup(atColumn: column, row: row) { //if there is a tile filled at this location
                    var nodeName = ""
                    var categoryBitMask: UInt32 = 0
                    if tileGroup.name?.contains("Grass") ?? false {
                        nodeName = "ground" //if it's grass it's ground
                        categoryBitMask = PhysicsCategory.ground
                        addSinglePhysicsBody(name: nodeName, column: column, row: row, categoryBitMask: categoryBitMask)
                        if !(tileMap.tileGroup(atColumn: column, row: row - 1)?.name?.contains("Grass") ?? false) { //if tile above is not grass
                            if Bool.randomTrue(probability: MapStats.enemySpawnChance) {
                                spawnEnemyAbove(column: column, row: row) //add a enemy above the tile
                            }
                        }
                    } else if tileGroup.name?.contains("Stone") ?? false {
                        nodeName = "wall"
                        categoryBitMask = PhysicsCategory.wall
                        addSinglePhysicsBody(name: nodeName, column: column, row: row, categoryBitMask: categoryBitMask)
                    }
                }
            }
        }
    }
    
    private func addSinglePhysicsBody(name: String, column: Int, row: Int, categoryBitMask: UInt32) {
        let tileSize = tileMap.tileSize
        
        let tileNode = SKSpriteNode(color: UIColor.clear, size: tileSize)
        tileNode.position = tileMap.centerOfTile(atColumn: column, row: row) //set tile position
        tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
        tileNode.physicsBody?.isDynamic = false //these map tile nodes don't move
        tileNode.physicsBody?.categoryBitMask = categoryBitMask //testing for contact for double jump purposes
        tileNode.physicsBody?.friction = 0.2 //provides friction for player to stop moving
        tileNode.physicsBody?.restitution = 0 //no bouncing
        tileNode.name = name
        tileMap.addChild(tileNode)
    }
    
    private func spawnEnemyAbove(column: Int, row: Int) {
        let tileSize = tileMap.tileSize
        let tilePosition = tileMap.centerOfTile(atColumn: column, row: row) //find tile position
        let enemyPosition = CGPoint(x: tilePosition.x, y: tilePosition.y + tileSize.height) //enemy position above the tile
        let enemy = Enemy(imageNamed: "Stickman", position: enemyPosition, zPosition: 0, name: "enemy", health: EnemyBaseStats.maxhealth)
        self.scene?.addChild(enemy)
    }
    
}
    

