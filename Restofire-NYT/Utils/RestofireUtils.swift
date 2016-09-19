//
//  RestofireUtils.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 20/09/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Restofire
import Alamofire
import Argo

extension ResponseSerializable where Self: Requestable, Self.Model: Decodable, Self.Model == Self.Model.DecodedType {
    
    public var dataResponseSerializer: Alamofire.DataResponseSerializer<Any> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                let decodedValue = Model.decode(JSON(json))
                switch decodedValue {
                case .success(let value):
                    return .success(value)
                case .failure(let error):
                    return .failure(error)
                }
            } catch {
                return .failure(DecodeError.custom("Failed to serialize json"))
            }
            
        }
        
    }
    
}
