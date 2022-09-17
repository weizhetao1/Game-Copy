//
//  File.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 14/09/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class Base: GKEntity {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture){
        node = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
