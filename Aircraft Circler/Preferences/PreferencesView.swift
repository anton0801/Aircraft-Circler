import SwiftUI

struct PreferencesView: View {
    
    @EnvironmentObject var soundsManager: SoundManager
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Image("settings_title")
                    .offset(x: -25)
                Spacer()
            }
            .padding(.top)
            Spacer()
            ZStack {
                Image("settings_items_bg")
                VStack {
                    Text("SOUND")
                        .font(.custom("Aviator-Bold", size: 28))
                        .foregroundColor(.white)
                    HStack {
                        Image("sound")
                        Button {
                            changeVolume()
                        } label: {
                            if soundsManager.soundEnabled {
                                Image("volume_on")
                            } else {
                                Image("volume_off")
                            }
                        }
                    }
                }
            }
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("settings_item_done_btn")
            }
            .offset(y: -25)
            
            Spacer()
        }
        .background(
            Image("menu_back")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height + 50)
                .ignoresSafeArea()
        )
    }
    
    private func changeVolume() {
        withAnimation(.linear) {
            soundsManager.soundEnabled.toggle()
        }
    }
    
}

#Preview {
    PreferencesView()
        .environmentObject(SoundManager())
}
