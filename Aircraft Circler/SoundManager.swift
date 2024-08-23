import Foundation

class SoundManager: ObservableObject {
    
    @Published var soundEnabled = false {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "sounds")
            toggleMusic()
        }
    }
    
    func toggleMusic() {
    }
    
}
