//
//  MovieReview.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 02/05/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import RealmSwift

class MovieReview: Object {
    
    dynamic var displayTitle: String!
    dynamic var summary: String!
    
    override static func primaryKey() -> String? {
        return "displayTitle"
    }
    
}