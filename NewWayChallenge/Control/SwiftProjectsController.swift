//
//  SwiftProjectsController.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class SwiftProjectsController {
    private static let recordsPerPage = 30
    
    private let _serviceClient = ServiceClientFactory.acquireServiceClient()
    private var _currentPage = 1;
    
    private(set) var repositories = [Repository]()
    private(set) var hasMore = false
    
    func getMore(
        callback: @escaping (SwiftProjectsController, ResponseError?) -> ()
        ) {
        _serviceClient.getPopularSwiftRepositories(page: _currentPage) {
            [weak self] (repos, error) in
            if let strongSelf = self {
                if error == nil {
                    let fixedRepos = repos ?? []
                    strongSelf.repositories.append(contentsOf: fixedRepos)
                    strongSelf.hasMore = fixedRepos.count >= SwiftProjectsController.recordsPerPage;
                }
                callback(strongSelf, error)
            }
        }
    }
    
    func reset() {
        _currentPage = 1
        repositories.removeAll()
    }
}
