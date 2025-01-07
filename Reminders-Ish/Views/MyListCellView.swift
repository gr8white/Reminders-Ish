import SwiftUI
import SwiftData

struct MyListCellView: View {
    
    let list: MyList
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color(hex: list.colorCode))
            
            Text(list.name)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MyListCellViewContainer: View {
    
    @Query private var myLists: [MyList]
    
    var body: some View {
        MyListCellView(list: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListCellViewContainer()
            .modelContainer(previewContainer)
    }
}
