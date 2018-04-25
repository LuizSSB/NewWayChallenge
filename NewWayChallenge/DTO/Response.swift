//
//  Response.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class Response: BaseDTO {
    var message: String?
    var errors: [ResponseError]?
    
    var mainError: ResponseError? {
        if let errors = errors {
            return errors[0]
        }
        
        if let message = message as NSString?,
            message.range(of: "API rate").location != NSNotFound {
            return ResponseError(code: .apiRateLimit)
        }
        
        return nil
    }
}
