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
    static let sword: UInt32 = 1 << 6
}

enum PlayerBaseStats {
    static let horizontalMoveSpeed: CGFloat = 150
    static let jumpSpeed: CGFloat = 500
    static let bulletSpeed: CGFloat = 200
    static let friction: CGFloat = 0.6
}

enum SceneInfo {
    static var size: CGSize = CGSize()
}

enum PhysicsWorldBaseStats {
    static var timeSlowFactor: CGFloat = 0.3
    static var gravity: CGFloat = -9.8
}
