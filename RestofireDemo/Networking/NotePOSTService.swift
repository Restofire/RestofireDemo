//
//  NotePOSTService.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 14/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire
import CoreData

struct NotePOSTService: Requestable {
    
    typealias Response = NoteResponseModel
    let path: String? = "notes"
    let method: HTTPMethod = .post
    var parameters: Any?
    let context: NSManagedObjectContext
    
    init(parameters: NoteRequestModel, context: NSManagedObjectContext) {
        let data = try! JSONEncoder().encode(parameters)
        self.parameters = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        self.context = context
    }
    
}

extension NotePOSTService {
    
    func request(_ request: RequestOperation<NotePOSTService>, didCompleteWithValue value: NoteResponseModel) {
        context.performAndWait() {
            Note.insert(model: value, into: context)
            do {
                try context.save()
            } catch {
                print("Failed to save objects: \(error)")
            }
        }
    }
    
}
