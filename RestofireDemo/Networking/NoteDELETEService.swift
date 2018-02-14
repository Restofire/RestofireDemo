//
//  NoteDELETEService.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 14/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire
import CoreData

struct NoteDeleteService: Requestable {
    
    typealias Response = Data
    let path: String?
    let method: HTTPMethod = .delete
    var id: Int16
    let context: NSManagedObjectContext
    
    init(id: Int16, context: NSManagedObjectContext) {
        self.id = id
        self.path = "notes/\(id)"
        self.context = context
    }
    
}

extension NoteDeleteService {

    func request(_ request: RequestOperation<NoteDeleteService>, didCompleteWithValue value: Data) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        do {
            if let object = try context.fetch(fetchRequest).first {
                context.delete(object)
                try context.save()
            }
        } catch {
            print("Failed to delete object: \(error)")
        }
    }

}
