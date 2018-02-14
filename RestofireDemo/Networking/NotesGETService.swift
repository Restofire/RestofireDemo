//
//  NotesGETService.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 14/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire
import CoreData

struct NotesGetAllService: Requestable {
    
    typealias Response = [NoteResponseModel]
    var path: String? = "notes"
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
}

extension NotesGetAllService {
    
    func request(_ request: RequestOperation<NotesGetAllService>, didCompleteWithValue value: [NoteResponseModel]) {
        context.performAndWait() {
            value.forEach { Note.insert(model: $0, into: context) }
            do {
                try context.save()
            } catch {
                print("Failed to save objects: \(error)")
            }
        }
    }
    
}
