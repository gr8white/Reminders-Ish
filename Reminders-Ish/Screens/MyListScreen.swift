import SwiftUI

struct MyListScreen: View {
    
    let myLists = ["Work", "Personal", "Family"]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
            ForEach(myLists, id: \.self) { list in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .font(.system(size: 32))
                    
                    Text(list)
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

#Preview {
    MyListScreen()
}
