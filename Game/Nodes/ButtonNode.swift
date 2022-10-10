//
//  ButtonNode.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 01/10/2022.
//

import Foundation
import SpriteKit

class ButtonNode: SKShapeNode {
    
    private var action: () -> Void = {} //Empty function for error at super.init, doesn't change functionality
    
    override init() {
        super.init()
    }
    
    convenience init(position: CGPoint, zPosition: CGFloat, name: String, action: @escaping () -> Void) {
        self.init()
        self.init(circleOfRadius: 20)
        self.fillColor = UIColor(white: 0.5, alpha: 0.3)
        self.position = position
        self.zPosition = zPosition
        self.name = name
        self.action = action
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode == self {
                action()
            }
        }
    }
}
