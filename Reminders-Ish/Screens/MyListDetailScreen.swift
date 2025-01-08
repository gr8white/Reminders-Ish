import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    
    var myList: MyList
    @Query private var reminders: [Reminder]
    
    @State private var title: String = ""
    @State private var isNewReminderAlertPresented: Bool = false
    
    @Environment(\.modelContext) private var context
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders?.append(reminder)
        title = ""
        
        try! context.save()
    }
    
    init(myList: MyList) {
        self.myList = myList
        
        let listId = myList.persistentModelID
        
        let predicate = #Predicate<Reminder> { reminder in
            reminder.list?.persistentModelID == listId
            && !reminder.isCompleted
        }
        
        _reminders = Query(filter: predicate)
    }
    
    var body: some View {
        VStack {
            ReminderListView(reminders: myList.reminders?.filter { !$0.isCompleted } ?? [])
            
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
