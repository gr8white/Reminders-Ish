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
    let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for list in SampleData.myLists {
        container.mainContext.insert(list)
        list.reminders = SampleData.reminders
    }
    
    return container
}()

struct SampleData {
    static var myLists: [MyList] {
        return [MyList(name: "Reminders", colorCode: "#2ecc71"), MyList(name: "Backlog", colorCode: "#9b59b6")]
    }
    
    static var reminders: [Reminder] {
        return [Reminder(title: "Reminder 1", notes: "This is a reminder 1 note", reminderDate: Date()), Reminder(title: "Reminder 2", notes: "This is a reminder 2 note", reminderDate: Date())]
    }
}
