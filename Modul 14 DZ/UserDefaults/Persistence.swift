
import Foundation

final class Persistence{
    static let share = Persistence()
    
    private let nameKey = "Persistence.nameKey"
    private let lastNameKey = "Persistence.lastNameKey"
    
    var name: String?{
        set { UserDefaults.standard.set(newValue, forKey: nameKey) }
        get { return UserDefaults.standard.string(forKey: nameKey) }
    }
    
    var lastName: String?{
        set { UserDefaults.standard.set(newValue, forKey: lastNameKey) }
        get { return UserDefaults.standard.string(forKey: lastNameKey) }
    }
}
