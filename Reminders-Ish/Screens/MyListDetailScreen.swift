import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    
    var myList: MyList
    @State private var title: String = ""
    @State private var isNewReminderAlertPresented: Bool = false
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    
    @Environment(\.modelContext) private var context
    
    private let delay = Delay()
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders.append(reminder)
        title = ""
        
        try! context.save()
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        context.delete(myList.reminders[index])
        
        try! context.save()
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(myList.reminders.filter { !$0.isCompleted }) { reminder in
                    ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                        switch event {
                        case .onChecked(let reminder, let checked):
                            delay.cancelWork()
                            delay.performWork {
                                reminder.isCompleted = checked
                            }
                        case .onSelect(let reminder):
                            selectedReminder = reminder
                        case .onInfoSelected(let reminder):
                            showReminderEditScreen = true
                            selectedReminder = reminder
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
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
