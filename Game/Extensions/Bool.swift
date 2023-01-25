//
//  Bool.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 25/01/2023.
//

import Foundation
import SpriteKit

extension Bool {
    static func randomTrue(probability: CGFloat) -> Bool {
        let randomFloat = CGFloat.random(in: 0...1)
        return (randomFloat / probability) <= 1
    }
}
