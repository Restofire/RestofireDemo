//
//  MovieReview.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 02/05/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Realm
import RealmSwift
import Argo
import Curry
import Runes

final class MovieReview: Object, Decodable  {
    
    dynamic var displayTitle: String = ""
    dynamic var summary: String = ""
    
    init(displayTitle: String, summary: String) {
        self.displayTitle = displayTitle
        self.summary = summary
        super.init()
    }
    
    override static func primaryKey() -> String? {
        return "displayTitle"
    }
    
    static func decode(_ json: JSON) -> Decoded<MovieReview> {
        return curry(self.init)
            <^> json <| "display_title"
            <*> json <| "summary_short"
    }
    
    // For realm's sake
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
