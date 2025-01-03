import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    
    var myList: MyList
    @State private var title: String = ""
    @State private var isNewReminderAlertPresented: Bool = false
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders.append(reminder)
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    var body: some View {
        VStack {
            List(myList.reminders) { reminder in
                ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):
                        reminder.isCompleted = checked
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    case .onInfoSelected(let reminder):
                        showReminderEditScreen = true
                        selectedReminder = reminder
                    }
                }
            }
            
            Spacer()
            
            Button {
                isNewReminderAlertPresented = true
            } label: {
                HStack {
                    Text("New Reminder")
                    Image(systemName: "plus.circle.fill")
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()

        }
        .navigationTitle(myList.name)
        .alert("New Reminder", isPresented: $isNewReminderAlertPresented) {
            TextField("", text: $title)
            Button("Cancel", role: .cancel) { }
            Button("Done") {
                saveReminder()
            }
            .disabled(!isFormValid)
        }
        .sheet(isPresented: $showReminderEditScreen) {
            if let selectedReminder {
                NavigationStack {
                    ReminderEditScreen(reminder: selectedReminder)
                }
            }
        }
    }
}

struct MyListDetailScreenContainer: View {
    
    @Query private var myLists: [MyList]
    
    var body: some View {
        MyListDetailScreen(myList: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListDetailScreenContainer()
            .modelContainer(previewContainer)
    }
}
