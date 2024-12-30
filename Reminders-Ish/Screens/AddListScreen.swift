import SwiftUI

struct AddListScreen: View {
    
    @State private var listName: String = ""
    @State private var selectedColor: Color = .blue
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
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
                    guard let hexCode = selectedColor.toHex() else { return }
                    
                    let list = ListModel(name: listName, colorCode: hexCode)
                    
                    context.insert(list)
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
