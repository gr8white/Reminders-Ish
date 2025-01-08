import Foundation
import SwiftData

@Model
class MyList {
    var name: String = ""
    var colorCode: String = ""
    
    @Relationship(deleteRule: .cascade)
    var reminders: [Reminder]? = []
    
    init(name: String, colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
}
