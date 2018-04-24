//
//  Repository.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class Repository: BaseDTO, QueryableEntity {    
    var name: String?
    var repoDescription: String?
    var forksCount: Int?
    var stargazersCount: Int?
    var owner: RepositoryOwner?
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(
            value, forKey: key == "description" ? "repoDescription" : key
        )
    }
    
    static var path: String {
        return "repositories"
    }
}

class RepositoriesQueryResponse: Response {
    var items: [Repository]?
}
