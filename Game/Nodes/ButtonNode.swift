//
//  ButtonNode.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 01/10/2022.
//

import Foundation
import SpriteKit

enum ButtonNodeState {
    case active, selected
}

class ButtonNode: SKShapeNode {
    
    private var action: () -> Void = {} //Empty function for error at super.init, doesn't change functionality
    private var endAction: () -> Void = {} //Function called when the button touch ends
    private var state: ButtonNodeState = .active {
        didSet {
            switch state {
            case .active:
                endAction() //Calls endAction when the button returns to active (not pressed)
                break
            case .selected:
                action() //Calls action when pressed
                break
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(position: CGPoint, zPosition: CGFloat, name: String, action: @escaping () -> Void, endAction: @escaping () -> Void = {}) {
        // No need to specify endAction if not wanted. Will be an empty closure by default
        self.init()
        self.init(circleOfRadius: 20)
        self.fillColor = UIColor(white: 0.5, alpha: 0.3)
        self.position = position
        self.zPosition = zPosition
        self.name = name
        self.action = action
        self.endAction = endAction
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected //sets the button to pressed when pressed
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if !self.frame.contains(location) {
                state = .active //resets the button state if touch leaves the frame of the button node.
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .active //resets the button state
    }
}
