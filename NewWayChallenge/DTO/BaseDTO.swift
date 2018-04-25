//
//  BaseDTO.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import EVReflection

fileprivate func fixSnakeCase(str: String) -> String {
    var camelCase = ""
    str.split(separator: "_").enumerated().forEach {
        (offset: Int, element: String.SubSequence) in
        camelCase += 0 == offset
            ? element.description : element.description.uppercased()
    }
    return camelCase
}

class BaseDTO: EVNetworkingObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let fixedKey = fixSnakeCase(str: key)
        super.setValue(value, forKey: fixedKey)
    }
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        // luizssb: ignored
    }
}
