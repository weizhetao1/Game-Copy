//
//  ContentView.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 12/09/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
