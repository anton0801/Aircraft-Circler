import Foundation

class UserManager: ObservableObject {
    
    @Published var money = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            UserDefaults.standard.set(money, forKey: "money")
        }
    }
    @Published var lives = 3
    
}
