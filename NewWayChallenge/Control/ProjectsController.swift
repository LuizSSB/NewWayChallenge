//
//  ProjectsController.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class ProjectsController {
    private static let initialPage = 1
    private static let recordsPerPage = 30
    static let recommendedAcquisitionIndex =
        Int(Float(ProjectsController.recordsPerPage) * 0.75)
    
    init(language: String, sortFields: [String]? = ["stars"]) {
        self.language = language
        self.sortFields = sortFields
    }
    
    private var _repositories = [Repository]()
    private let _serviceClient = ServiceClientFactory.acquireServiceClient()
    
    weak var delegate: ProjectsControllerDelegate?
    private(set) var language: String
    private(set) var sortFields: [String]?
    
    private(set) var currentPage = ProjectsController.initialPage;
    private(set) var busy = false
    private(set) var hasMore = true
    var count: Int {
        return _repositories.count
    }
    subscript(index: Int) -> Repository {
        get {
            return _repositories[index]
        }
    }
    
    private func getMore() {
        if busy {
            return
        }
        
        busy = true
        delegate?.projecControllerWillGetEntries(self)
        
        _serviceClient.getRepositories(
            of: language, page: currentPage, sortedBy: sortFields
        ) {
            [weak self] (repos, error) in
            if let strongSelf = self {                
                if let error = error {
                    strongSelf.delegate?
                        .projectController(strongSelf, didFail: error)
                } else {
                    let fixedRepos = repos ?? []
                    strongSelf._repositories.append(contentsOf: fixedRepos)
                    strongSelf.currentPage += 1
                    strongSelf.hasMore =
                        fixedRepos.count >= ProjectsController.recordsPerPage
                    
                    strongSelf.delegate?
                        .projectController(strongSelf, didGetEntries: fixedRepos)
                }
                
                strongSelf.busy = false
            }
        }
    }
    
    func start () {
        reset()
    }
    
    func reset() {
        hasMore = true
        currentPage = ProjectsController.initialPage
        _repositories.removeAll()
        
        getMore()
    }
}

protocol ProjectsControllerDelegate: class {
    func projecControllerWillGetEntries(_ controller: ProjectsController)
    func projectController(
        _ controller: ProjectsController, didGetEntries entries: [Repository]
    )
    func projectController(
        _ controller: ProjectsController, didFail error: ResponseError
    )
}
