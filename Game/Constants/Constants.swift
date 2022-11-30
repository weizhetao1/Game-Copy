//
//  Textures.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 23/11/2022.
//

import Foundation
import SpriteKit

enum BulletTexture {
    static let bulletBlue = SKTexture(imageNamed: "BulletBlue")
}

enum PhysicsCategory {
    static let player: UInt32 = 1
    static let wall: UInt32 = 1 << 1
    static let ground: UInt32 = 1 << 2
    static let enemy: UInt32 = 1 << 3
    static let platform: UInt32 = 1 << 4
    static let bullet: UInt32 = 1 << 5
}
