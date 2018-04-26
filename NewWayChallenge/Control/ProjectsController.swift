//
//  ProjectsController.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class ProjectsController {
    static let timeToRetry: TimeInterval = 5
    static let initialPage = 1
    static let recordsPerPage = 30
    
    init(language: String, sortFields: [String]? = ["stars"]) {
        self.language = language
        self.sortFields = sortFields
    }
    
    private var _retryTimer: Timer?
    private var _currentRequest: Cancellable?
    private var _repositories = [Repository]()
    private let _serviceClient = ServiceClientFactory.acquireServiceClient()
    
    weak var delegate: ProjectsControllerDelegate?
    private(set) var language: String
    private(set) var sortFields: [String]?
    private(set) var currentPage = ProjectsController.initialPage;
    private(set) var hasMore = true
    
    var count: Int {
        return _repositories.count
    }
    
    var acquisitionIndex: Int {
        guard _retryTimer == nil && _currentRequest == nil && hasMore else {
            return Int.max
        }
        
        return max(count - ProjectsController.recordsPerPage / 2, 0)
    }
    
    subscript(index: Int) -> Repository {
        get {
            if index >= acquisitionIndex && hasMore {
                getPage(currentPage + 1)
            }
            
            return _repositories[index]
        }
    }
    
    private func getPage(_ page: Int, warnOnfailure: Bool = true) {
        delegate?.projecControllerWillGetEntries(self)
        
        _currentRequest = _serviceClient.getRepositories(
            of: language, page: page, sortedBy: sortFields
        ) {
            [weak self] (repos, error) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf._currentRequest = nil
            
            if let error = error {
                if (warnOnfailure) {
                    strongSelf.delegate?
                        .projectController(strongSelf, didFail: error)
                }
                strongSelf.retry(page: page)
                
            } else {
                let fixedRepos = repos ?? []
                strongSelf._repositories.append(contentsOf: fixedRepos)
                strongSelf.currentPage = page
                strongSelf.hasMore =
                    fixedRepos.count >= ProjectsController.recordsPerPage
                
                strongSelf.delegate?
                    .projectController(strongSelf, didGetEntries: fixedRepos)
            }
        }
    }
    
    func start () {
        reset()
    }
    
    func reset() {
        _retryTimer?.invalidate()
        _retryTimer = nil
        
        _currentRequest?.cancel()
        _currentRequest = nil
        
        hasMore = true
        _repositories.removeAll()
        getPage(ProjectsController.initialPage)
    }
    
    func retry(page: Int) {
        guard page != ProjectsController.initialPage else {
            return
        }
        
        self._retryTimer = Timer.scheduledTimer(
            withTimeInterval: ProjectsController.timeToRetry,
            repeats: false
        ) { [weak self] timer in
            self?._retryTimer = nil
            self?.getPage(page, warnOnfailure: false)
        }
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
