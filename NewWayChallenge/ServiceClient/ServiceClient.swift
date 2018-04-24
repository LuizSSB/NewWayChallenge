//
//  ServiceClient.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

typealias ArrayServiceCallback<T> = ([T]?, ResponseError?) -> ()


protocol ServiceClient {
    func getRepositories(
        of language: String, page: Int, sortedBy sortFields: [String]?,
        callback: @escaping ArrayServiceCallback<Repository>
    )
}

extension ServiceClient {
    func getPopularSwiftRepositories(
        page: Int, callback: @escaping ArrayServiceCallback<Repository>
    ) {
        self.getRepositories(
            of: "Swift", page: page, sortedBy: ["stars"], callback: callback
        )
    }
}

extension QueryableEntity {
    static var url: URL {
        return URL(string: "https://api.github.com/search/" + self.path)!
    }
}
