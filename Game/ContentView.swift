//
//  ContentView.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 12/09/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene(size: CGSize(width: 667, height: 350))
    var body: some View {
        VStack {
            SpriteView(scene: scene)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
