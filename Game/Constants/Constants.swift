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
    static var size: CGFloat = 32
    static var maxHealth: CGFloat = 150
    static var startingHealth: CGFloat = 100
    static var bulletDamage: CGFloat = 10
    static var meleeDamage: CGFloat = 15
    static let horizontalMoveSpeed: CGFloat = 80
    static let jumpSpeed: CGFloat = 400
    static let bulletSpeed: CGFloat = 100
    static let friction: CGFloat = 0.6
}

enum EnemyBaseStats {
    static var size: CGFloat = 32
    static var maxhealth: CGFloat = 100
    static var bulletDamage: CGFloat = 1
    static var bulletSpeed: CGFloat = 100
    static var shootingChance: CGFloat = 0.005 //chance of chooting per frame
    static var meleeDamage: CGFloat = 3
}

enum MeleeWeaponStats {
    static let swingTime: CGFloat = 0.12
    static let size: CGFloat = 1500
}

enum SceneInfo {
    static var size: CGSize = CGSize()
}

enum PhysicsWorldBaseStats {
    static var timeSlowFactor: CGFloat = 0.3
    static var gravity: CGFloat = -6
}

enum MapStats {
    static var enemySpawnChance: CGFloat = 0.1
}
