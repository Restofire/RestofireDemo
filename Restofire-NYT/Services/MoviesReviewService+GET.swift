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
    
    typealias Model = NYTResponse
    var path: String = "reviews/"
    var parameters: Any?
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(path: String, parameters: Any) {
        self.path += path
        self.parameters = parameters
    }
    
}

// MARK: - Caching
import RealmSwift
import Argo

extension MoviesReviewGETService {
    
    func didCompleteRequestWithDataResponse(_ response: DataResponse<Model>) {
        guard let nytResponse = response.result.value else { return }
        if nytResponse.status == "OK" {
            let realm = try! Realm()
            for result in nytResponse.results! {
                try! realm.write { realm.add(result, update: true) }
            }
        }
    }
    
}
