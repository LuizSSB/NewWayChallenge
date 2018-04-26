//
//  MockServiceClient.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/26/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class MockServiceClient: ServiceClient {
    var fails = false
    var returnedElements = 6
    
    func getRepositories(
        of language: String, page: Int, sortedBy sortFields: [String]?,
        callback: @escaping ArrayServiceCallback<Repository>
        ) -> Cancellable {
        var data: [Repository]?
        
        if returnedElements >= 0 {
            data = []
            data?.append(contentsOf: (0..<returnedElements).map {
                idx -> Repository in
                let strIdx = String(idx)
                let r = Repository()
                r.forksCount = idx + 1
                r.stargazersCount = idx + 2
                r.name = "Repo " + strIdx
                r.repoDescription = "Description " + strIdx
                r.watchersCount = idx + 3
                
                r.owner = RepositoryOwner()
                r.owner.avatarURL = URL(string: "https://avatars3.githubusercontent.com/u/7774181?v=4")
                r.owner.login = "Owner " + strIdx
                r.owner.type = "Type " + strIdx
                
                return r
            })
        }
        return MockCancellable(callback: callback, data: data, fails: fails)
            .prepare()
    }
    
    func setup() {
    }
    
    class MockCancellable<T>: Cancellable {
        let timeToFinish: TimeInterval = 1
        var timer: Timer?
        
        let callback: ArrayServiceCallback<T>
        let data: [T]?
        let fails: Bool
        
        init(
            callback: @escaping ArrayServiceCallback<T>, data: [T]?, fails: Bool
            ) {
            self.callback = callback
            self.data = data
            self.fails = fails
        }
        
        func cancel() {
            timer?.invalidate()
        }
        
        func prepare() -> MockCancellable {
            timer  = Timer.scheduledTimer(withTimeInterval: timeToFinish, repeats: false) {
                [unowned self] _ in
                if self.fails {
                    self.callback(nil, ResponseError.generic)
                } else {
                    self.callback(self.data, nil)
                }
            }
            
            return self
        }
    }
}
