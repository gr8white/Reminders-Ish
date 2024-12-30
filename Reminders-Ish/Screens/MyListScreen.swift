import SwiftUI
import SwiftData

struct MyListScreen: View {
    
    @Query private var myLists: [ListModel]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
            ForEach(myLists) { list in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Color(hex: list.colorCode))
                    
                    Text(list.name)
                }
            }
            
            Button {
                isPresented = true
            } label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.listRowSeparator(.hidden)

        }
        .listStyle(.plain)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddListScreen()
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListScreen()
            .modelContainer(previewContainer)
    }
}
