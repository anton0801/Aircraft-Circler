import SwiftUI

struct ContentView: View {
    
    @StateObject var soundsManager = SoundManager()
    @StateObject var userManager = UserManager()
    
    var body: some View {
        NavigationView {
            HStack(spacing: 42) {
                Spacer()
                VStack {
                    ZStack {
                        Image("credits_back")
                        Text("0")
                            .font(.custom("Aviator-Bold", size: 24))
                            .foregroundColor(.white)
                            .offset(x: 25)
                    }
                    Spacer()
                }
                VStack {
                    ZStack {
                        Image("lives_back")
                        Text("0")
                            .font(.custom("Aviator-Bold", size: 24))
                            .foregroundColor(.white)
                            .offset(x: 25)
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    NavigationLink(destination: PreferencesView()
                        .environmentObject(soundsManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("settings_btn")
                    }
                    Spacer()
                    NavigationLink(destination: MapLevelsView()
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                    }
                    Spacer()
                    NavigationLink(destination: RulesView()
                        .navigationBarBackButtonHidden(true)) {
                        Image("rules_btn")
                    }
                    Spacer()
                }
            }
            .background(
                Image("menu_back")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height + 50)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
