import SwiftUI

struct MapLevelsView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ScrollViewReader { proxy2 in
                            ScrollView(.horizontal) {
                                ZStack(alignment: .bottom) {
                                    Image("level_map")
                                        .resizable()
                                        .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                                        .aspectRatio(contentMode: .fill)
                                        .id("level_map")
                                    
                                    ZStack {
                                        NavigationLink(destination: CirclerGameView(level: 6)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("6")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -870, y: -1290)
                                        .id(6)
                                        
                                        NavigationLink(destination: CirclerGameView(level: 5)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("5")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -790, y: -1460)
                                        .id(5)
                                        
                                        NavigationLink(destination: CirclerGameView(level: 4)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("4")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -670, y: -1620)
                                        .id(4)
                                        
                                        NavigationLink(destination: CirclerGameView(level: 3)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("3")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -530, y: -1740)
                                        .id(3)
                                        
                                        NavigationLink(destination: CirclerGameView(level: 2)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("2")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -400, y: -1820)
                                        .id(2)
                                        
                                        NavigationLink(destination: CirclerGameView(level: 1)
                                            .environmentObject(userManager)
                                            .navigationBarBackButtonHidden(true)) {
                                            ZStack {
                                                Image("available_level")
                                                    .resizable()
                                                    .frame(width: 70, height: 70)
                                                Text("1")
                                                    .font(.custom("Aviator-Bold", size: 42))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -250, y: -1870)
                                        .id(1)
                                    }
                                }
                            }
                            .id("map")
                            .onAppear {
                                withAnimation {
                                    proxy2.scrollTo(4)
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo("map", anchor: .top)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Button {
                            presMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_btn")
                        }
                        Spacer()
                        Image("levels_title")
                            .offset(x: -25)
                        Spacer()
                    }
                    .padding(.top)
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MapLevelsView()
        .environmentObject(UserManager())
}
