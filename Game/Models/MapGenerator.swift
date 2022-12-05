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
    
    func setUpTileMap(fileNamed fileName: String) {
        guard let tileScene = SKScene(fileNamed: fileName),
              let map = tileScene.childNode(withName: "Map1") as? SKTileMapNode else {
                  fatalError("Map1 not loaded")
              } //loading tile map node from the sks file and making sure it is a tile map
        map.removeFromParent()
        map.anchorPoint = CGPoint(x: 0, y: 0)
        tileMap = map
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        let tileSize = tileMap.tileSize
        
        for column in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row) { //if there is a tile filled at this location
                    var nodeName = ""
                    var categoryBitMask: UInt32 = 0
                    if tileDefinition.name?.contains("Grass") ?? false {
                        nodeName = "ground"
                        categoryBitMask = PhysicsCategory.ground
                    } else if tileDefinition.name?.contains("Cobblestone") ?? false {
                        nodeName = "wall"
                        categoryBitMask = PhysicsCategory.wall
                    }
                    let tileNode = SKSpriteNode(color: UIColor.clear, size: tileSize)
                    tileNode.position = tileMap.centerOfTile(atColumn: column, row: row) //set tile position
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                    tileNode.physicsBody?.isDynamic = false //these map tile nodes don't move
                    tileNode.physicsBody?.categoryBitMask = categoryBitMask //testing for contact for double jump purposes
                    tileNode.physicsBody?.friction = 0.2 //provides friction for player to stop moving
                    tileNode.physicsBody?.restitution = 0 //no bouncing
                    tileNode.name = nodeName
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
    
}
    

