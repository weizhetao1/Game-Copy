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

enum PlayerTextures {
    static let right = SKTexture(imageNamed: "PlayerRight")
    static let left = SKTexture(imageNamed: "PlayerLeft")
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
    static var size: CGFloat = 26
    static var maxHealth: CGFloat = 150
    static var startingHealth: CGFloat = 150
    static var bulletDamage: CGFloat = 10
    static var meleeDamage: CGFloat = 15
    static let horizontalMoveSpeed: CGFloat = 80
    static let jumpSpeed: CGFloat = 400
    static let bulletSpeed: CGFloat = 100
    static let friction: CGFloat = 0.6
}

enum EnemyBaseStats {
    static var size: CGFloat = 24
    static var maxhealth: CGFloat = 100
    static var bulletDamage: CGFloat = 10
    static var bulletSpeed: CGFloat = 100
    static var shootingChance: CGFloat = 0.05 //chance of chooting per frame
    static var meleeDamage: CGFloat = 3
}

enum MeleeWeaponStats {
    static let swingTime: CGFloat = 0.12
    static let size: CGFloat = 80
}

enum SceneInfo {
    static var size: CGSize = CGSize()
}

enum PhysicsWorldBaseStats {
    static var timeSlowFactor: CGFloat = 0.3
    static var gravity: CGFloat = -6
}

enum MapStats {
    static var enemySpawnChance: CGFloat = 0.12
}

enum Messages {
    static let pauseMessage = "Press Pause Button Again to Resume"
    static let completeMessage = "Well done! Entering new level soon..."
    static let diedMessage = "Bad luck! Trying again soon..."
}
