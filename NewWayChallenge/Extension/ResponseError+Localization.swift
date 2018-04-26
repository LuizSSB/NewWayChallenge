//
//  ResponseError.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/25/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

extension ResponseError {
    var localizedCodeMessage: String {
        return NSLocalizedString("message:" + code.rawValue, comment:"Errors")
    }
}
