//
//  ResponseError.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

enum ErrorCode: String {
    // luizssb: default
    case missing, invalid
    
    // luizssb: custom
    case apiRateLimit
    
    // luizssb: fallback
    case unknown
}

class ResponseError: BaseDTO, Error {
    var code: ErrorCode
    
    init(code: ErrorCode = .unknown) {
        self.code = code
    }
    
    required convenience init() {
        self.init(code: .unknown)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "code", let value = value as? String {
            self.code = ErrorCode(rawValue: value) ?? .unknown
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static let generic = ResponseError()
}
