//
//  SKNode.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 07/11/2022.
//

import Foundation
import SpriteKit

extension SKNode {
    func distanceTo(node: SKNode) -> CGFloat {
        return hypot(self.position.x - node.position.x, self.position.y - node.position.y)
    }
}
