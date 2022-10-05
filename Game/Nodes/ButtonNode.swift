//
//  ButtonNode.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 01/10/2022.
//

import Foundation
import SpriteKit

class ButtonNode: SKShapeNode {
    
    override init() {
        super.init()
    }
    
    convenience init(position: CGPoint, zPosition: CGFloat, name: String) {
        self.init()
        self.init(circleOfRadius: 20)
        self.fillColor = UIColor(white: 0.5, alpha: 0.3)
        self.position = position
        self.zPosition = zPosition
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode == self {

            }
        }
    }
}
