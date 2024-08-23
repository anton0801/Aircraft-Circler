import SwiftUI

struct RulesView: View {
    
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
                Image("rules_title")
                    .offset(x: -25)
                Spacer()
            }
            .padding(.top)
            
            Text("Use the joystick to control the airplane. Fly through rings that match the airplane's color to earn points and coins. Passing through a ring of the wrong color will cost you one of your three lives. Keep the airplane airborne, or the game will end. As time progresses, the speed and sensitivity will increase. You can spend coins on new backgrounds. Good luck!")
                .font(.custom("Aviator-Bold", size: 22))
                .foregroundColor(.white)
                .frame(width: 500)
                .shadow(color: .black, radius: 2, x: 3, y: 2)
                .multilineTextAlignment(.center)
                
        }
        .preferredColorScheme(.dark)
        .background(
            Image("rules_back")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height + 50)
                .opacity(1)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    RulesView()
}
