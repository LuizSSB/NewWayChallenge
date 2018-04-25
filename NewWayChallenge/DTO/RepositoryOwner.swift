//
//  RepositoryOwner.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import EVReflection

class RepositoryOwner: BaseDTO {
    var login: String?
    var avatarURL: URL?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "avatar_url", let value = value as? String {
            avatarURL = URL(string: value)
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
