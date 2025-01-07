import SwiftUI

struct AddListScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var listName: String = ""
    @State private var selectedColor: Color = .blue
    
    var myList: MyList? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(selectedColor)
            
            TextField("List Name", text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 44)
            
            ColorPickerView(selectedColor: $selectedColor)
        }
        .onAppear {
            if let myList {
                listName = myList.name
                selectedColor = Color(hex: myList.colorCode)
            }
        }
        .navigationTitle("New List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    if let myList {
                        myList.name = listName
                        myList.colorCode = selectedColor.toHex() ?? ""
                    } else {
                        guard let hexCode = selectedColor.toHex() else { return }
                        let list = MyList(name: listName, colorCode: hexCode)
                        context.insert(list)
                    }
                    
                    try! context.save()
                    dismiss()
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddListScreen()
    }
    .modelContainer(previewContainer)
}
