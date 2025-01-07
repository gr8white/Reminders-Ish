import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .today: return "Today"
        case .scheduled: return "Scheduled"
        case .all: return "All"
        case .completed: return "Completed"
        }
    }
}

struct MyListsScreen: View {
    
    @Query private var myLists: [MyList]
    @Query private var reminders: [Reminder]
    
    @State private var presentedSheet: MyListScreenSheets?
    @State private var selectedList: MyList?
    @State private var reminderStatsType: ReminderStatsType?
    
    enum MyListScreenSheets: Identifiable {
        case newList
        case editList(MyList)
        
        var id: Int {
            switch self {
            case .newList: return 1
            case .editList(let myList): return myList.hashValue
            }
        }
    }
    
    private var todayReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else {
                return false
            }
            
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter{ $0.isCompleted }
    }
    
    private var incompletedReminders: [Reminder] {
        reminders.filter{ !$0.isCompleted }
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .today: return todayReminders
        case .scheduled: return scheduledReminders
        case .all: return incompletedReminders
        case .completed: return completedReminders
        }
    }
    
    var body: some View {
        List {
            VStack {
                HStack {
                    ReminderStatsView(icon: "calendar", title: "Today", count: todayReminders.count)
                        .onTapGesture {
                            reminderStatsType = .today
                        }
                    
                    ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: scheduledReminders.count)
                        .onTapGesture {
                            reminderStatsType = .scheduled
                        }
                }
                
                HStack {
                    ReminderStatsView(icon: "calendar", title: "All", count: incompletedReminders.count)
                        .onTapGesture {
                            reminderStatsType = .all
                        }
                    
                    ReminderStatsView(icon: "calendar", title: "Completed", count: completedReminders.count)
                        .onTapGesture {
                            reminderStatsType = .completed
                        }
                }
            }
            
            ForEach(myLists) { list in
                NavigationLink(value: list) {
                    MyListCellView(list: list)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedList = list
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            presentedSheet = .editList(list)
                        }
                }
            }
            
            Button {
                presentedSheet = .newList
            } label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.listRowSeparator(.hidden)

        }
        .navigationTitle("My Lists")
        .navigationDestination(item: $reminderStatsType, destination: { reminderStatsType in
            NavigationStack {
                ReminderListView(reminders: reminders(for: reminderStatsType))
                    .navigationTitle(reminderStatsType.title)
            }
        })
        .navigationDestination(item: $selectedList) { myList in
            MyListDetailScreen(myList: myList)
        }
        .listStyle(.plain)
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .newList:
                NavigationStack {
                    AddListScreen()
                }
            case .editList(let myList):
                NavigationStack {
                    AddListScreen(myList: myList)
                }
            }
        }
    }
}

#Preview("Light Mode") { @MainActor in
    NavigationStack {
        MyListsScreen()
    }.modelContainer(previewContainer)
}

#Preview("Dark Mode") { @MainActor in
    NavigationStack {
        MyListsScreen()
    }.modelContainer(previewContainer)
        .environment(\.colorScheme, .dark)
}
