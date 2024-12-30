//
//  PreviewContainter.swift
//  Reminders-Ish
//
//  Created by Cool-Ish on 12/30/24.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {
    let container = try! ModelContainer(for: ListModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for list in SampleData.myLists {
        container.mainContext.insert(list)
    }
    
    return container
}()

struct SampleData {
    static var myLists: [ListModel] {
        return [ListModel(name: "Reminders", colorCode: "#2ecc71"), ListModel(name: "Backlog", colorCode: "#9b59b6")]
    }
}
