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

enum ButtonType: String {
    case moveLeft = "MoveLeft"
    case moveRight = "MoveRight"
    case jump = "Jump"
    case attack = "Attack"
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
    
    convenience init(type: ButtonType, action: @escaping () -> Void, endAction: @escaping () -> Void = {}) {
        // No need to specify endAction if not wanted. Will be an empty closure by default
        self.init()
        self.init(circleOfRadius: 20)
        self.fillColor = UIColor(white: 0.5, alpha: 0.9)
        self.position = buttonPosition(of: type)
        self.zPosition = 10
        self.action = action
        self.endAction = endAction
        self.isUserInteractionEnabled = true
        attachImage(of: type)
    }
    
    private func buttonPosition(of type: ButtonType) -> CGPoint {
        switch type {
        case .moveLeft:
            return CGPoint(x: SceneInfo.size.width * -0.37, y: SceneInfo.size.height * -0.25)
        case .moveRight:
            return CGPoint(x: SceneInfo.size.width * -0.29, y: SceneInfo.size.height * -0.25)
        case .jump:
            return CGPoint(x: SceneInfo.size.width * 0.28, y: SceneInfo.size.height * -0.20)
        case .attack:
            return CGPoint(x: SceneInfo.size.width * 0.35, y: SceneInfo.size.height * -0.25)
        }
    }
    
    private func attachImage(of type: ButtonType) {
        let imageName = type.rawValue
        self.fillTexture = SKTexture(imageNamed: imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected //sets the button to pressed when pressed
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let parent = self.parent else { return }
        for touch in touches {
            let location = touch.location(in: parent)
            if self.frame.contains(location) {
                state = .selected //sets button state if moved to the button.
            } else {
                state = .active //resets the button state if touch leaves the frame of the button node.
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .active //resets the button state
    }
}
