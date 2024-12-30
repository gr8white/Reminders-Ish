import SwiftUI

@main
struct Reminders_IshApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListScreen()
            }.modelContainer(for: MyList.self)
        }
    }
}
