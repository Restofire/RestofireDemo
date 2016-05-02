//
//  MoviesReviewService+GET.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 02/05/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Restofire
import Alamofire

struct MoviesReviewGETService: Requestable {
    
    typealias Model = AnyObject
    var path: String = "reviews/"
    var parameters: AnyObject?
    var encoding: ParameterEncoding = .URLEncodedInURL
    
    init(path: String, parameters: AnyObject) {
       self.path += path
       self.parameters = parameters
    }
    
}

// MARK: - Caching
import RealmSwift
import SwiftyJSON

extension MoviesReviewGETService {
    
    func didSucceedWithModel(model: AnyObject) {
        let realm = try! Realm()
        let jsonMovieReview = JSON(model)
        if let results = jsonMovieReview["results"].array {
            for result in results {
                let movieReview = MovieReview()
                movieReview.displayTitle = result["display_title"].stringValue
                movieReview.summary = result["summary_short"].stringValue
                try! realm.write {
                    realm.add(movieReview, update: true)
                }
            }
        }
    }
    
}
