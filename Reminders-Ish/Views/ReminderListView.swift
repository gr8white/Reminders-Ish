import SwiftUI
import SwiftData

struct ReminderListView: View {
    @Environment(\.modelContext) private var context
    
    var reminders: [Reminder]
    
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    @State private var reminderIdAndDelay: [PersistentIdentifier: Delay] = [: ]
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        context.delete(reminders[index])
        
        try! context.save()
    }
    
    var body: some View {
        List{
            ForEach(reminders) { reminder in
                ReminderCellView(reminder: reminder) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):
                        
                        var delay = reminderIdAndDelay[reminder.persistentModelID]
                        
                        if let delay {
                            delay.cancelWork()
                            reminderIdAndDelay.removeValue(forKey: reminder.persistentModelID)
                        } else {
                            delay = Delay()
                            reminderIdAndDelay[reminder.persistentModelID] = delay
                            delay?.performWork {
                                reminder.isCompleted = checked
                            }
                        }
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    }
                }
            }
            .onDelete(perform: deleteReminder)
        }
        .sheet(item: $selectedReminder) { selectedReminder in
            NavigationStack {
                ReminderEditScreen(reminder: selectedReminder)
            }
        }
    }
}

struct ReminderListViewContainer: View {
    
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderListView(reminders: reminders)
    }
}

#Preview { @MainActor in
    NavigationStack {
        ReminderListViewContainer()
            .modelContainer(previewContainer)
    }
}
