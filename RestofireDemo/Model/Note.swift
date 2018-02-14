//
//  Note+CoreDataClass.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 14/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//
//

import Foundation
import CoreData

struct NoteRequestModel: Encodable {
    var title: String
}

struct NoteResponseModel: Decodable {
    var id: Int16
    var title: String
}

@objc(Note)
public class Note: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var title: String
    
}

extension Note {
    
    static func insert(model: NoteResponseModel, into context: NSManagedObjectContext) {
        let note = Note(context: context)
        note.id = model.id
        note.title = model.title
    }
    
}
