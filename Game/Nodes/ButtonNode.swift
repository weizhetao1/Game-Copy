//
//  ButtonNode.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 01/10/2022.
//

import Foundation
import SpriteKit

class ButtonNode {
    static func button(position: CGPoint, zPosition: CGFloat, name: String) -> SKShapeNode {
        let button = SKShapeNode(circleOfRadius: 20)
        button.fillColor = UIColor(white: 0.5, alpha: 0.3)
        button.position = position
        button.zPosition = zPosition
        button.name = name
        
        return button
    }
}
