import SwiftUI
import SpriteKit

struct CirclerGameView: View {
    
    @Environment(\.presentationMode) var presMode
    var level: Int
    @State var gameScene: CirclerGameScene!
    
    var body: some View {
        VStack {
            if let gameScene = gameScene {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            gameScene = CirclerGameScene(level: level)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("to_map")), perform: { _ in
            presMode.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restart")), perform: { _ in
            gameScene = gameScene.restartGame()
        })
    }
    
}

#Preview {
    CirclerGameView(level: 1)
}
