//
//  ResponseError.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

enum ErrorCode: String {
    case missing, invalid
    case unknown
}

class ResponseError: BaseDTO, Error {
    var code: ErrorCode = .unknown
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "code", let value = value as? String {
            self.code = ErrorCode(rawValue: value) ?? .unknown
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static let generic = ResponseError()
}
