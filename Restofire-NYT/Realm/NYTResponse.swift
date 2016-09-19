//
//  NYTResponse.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 22/09/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Foundation

struct NYTResponse {
    
    let status: String
    let results: [MovieReview]?
    
}

import Argo
import Runes
import Curry

extension NYTResponse: Decodable {
    
    static func decode(_ json: JSON) -> Decoded<NYTResponse> {
        return curry(NYTResponse.init)
            <^> json <| "status"
            <*> json <||? "results"
    }
    
}
