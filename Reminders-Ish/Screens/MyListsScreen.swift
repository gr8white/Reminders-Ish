import SwiftUI
import SwiftData

struct MyListsScreen: View {
    
    @Query private var myLists: [MyList]
    
    @State private var presentedSheet: MyListScreenSheets?
    @State private var selectedList: MyList?
    
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
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
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
        .navigationDestination(item: $selectedList, destination: { myList in
            MyListDetailScreen(myList: myList)
        })
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

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }.modelContainer(previewContainer)
}
