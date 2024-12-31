import SwiftUI
import SwiftData

enum ReminderCellEvent {
    case onChecked(Reminder, Bool)
    case onSelect(Reminder)
    case onInfoSelected(Reminder)
}

struct ReminderCellView: View {
    
    let reminder: Reminder
    let isSelected: Bool
    let onEvent: (ReminderCellEvent) -> Void
    
    @State private var checked: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .padding(.trailing, 5)
                .onTapGesture {
                    checked.toggle()
                    onEvent(.onChecked(reminder, checked))
                }
            
            VStack {
                Text(reminder.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(reminderDate.formatted())
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted())
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1 : 0)
                .onTapGesture {
                    onEvent(.onInfoSelected(reminder))
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelect(reminder))
        }
    }
}

struct ReminderCellViewContainer: View {
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderCellView(reminder: reminders[0], isSelected: false) { _ in }
    }
}

#Preview { @MainActor in
    ReminderCellViewContainer()
        .modelContainer(previewContainer)
}
