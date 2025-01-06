import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    
    let reminder: Reminder
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now
    
    @State private var showCalendar: Bool = false
    @State private var showTime: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    private func updateReminder() {
        reminder.title = title
        reminder.notes = notes.isEmpty ? nil : notes
        reminder.reminderDate = showCalendar ? reminderDate : nil
        reminder.reminderTime = showTime ? reminderTime : nil
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }
            
            Section {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2 )
                    
                    Toggle(isOn: $showCalendar) {
                        EmptyView()
                    }
                }
                
                if showCalendar {
                    DatePicker("Select Date", selection: $reminderDate, in: .now..., displayedComponents: .date)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.red)
                        .font(.title2 )
                    
                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                .onChange(of: showTime) {
                    if showTime {
                        showCalendar = true
                    }
                }
                
                if showTime {
                    DatePicker("Select Date", selection: $reminderTime, in: .now..., displayedComponents: .hourAndMinute)
                }
            }
        }
        .onAppear {
            title = reminder.title
            notes = reminder.notes ?? ""
            reminderDate = reminder.reminderDate ?? .now
            reminderTime = reminder.reminderTime ?? .now
            showCalendar = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    updateReminder()
                    dismiss()
                }
            }
        }
    }
}

struct RemindereditScreenContainer: View {
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])
    }
}

#Preview {
    NavigationStack {
        RemindereditScreenContainer()
    }
    .modelContainer(previewContainer)
}
