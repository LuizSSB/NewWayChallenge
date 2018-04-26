//
//  AlamofireServiceClient.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator
import EVReflection

class AlamofireServiceClient: ServiceClient {
    static let timeoutTime: TimeInterval = 10
    
    private var _manager: SessionManager!
    
    func setup() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource =
            AlamofireServiceClient.timeoutTime
        _manager = SessionManager(configuration: configuration)
    }
    
    func getRepositories(
        of language: String, page: Int, sortedBy sortFields: [String]?,
        callback: @escaping ArrayServiceCallback<Repository>
    ) -> Cancellable {
        guard page > 0 else {
            defer {
                callback(nil, ResponseError(code: .invalid))
            }
            return NullCancellable.shared
        }
        
        var params: Parameters = [
            "q": "language:" + language,
            "page": page
        ]
        if let sortFields = sortFields {
            params["sort"] = sortFields.joined(separator: ",")
        }
        
        return GETRequest(for: Repository.self, params: params)
            .responseObject { (response: DataResponse<RepositoriesQueryResponse>) in
                switch response.result {
                case .success(let value):
                    callback(value.items, value.mainError)
                case .failure(let error):
                    guard (error as NSError).code != -999 else {
                        return
                    }
                    
                    callback(nil, ResponseError.generic)
                }
            }
            .nwc_asCancellable
    }
    
    private func GETRequest<T: QueryableEntity> (
        for entity: T.Type, params: [String: Any]?
    ) -> DataRequest {
        return _manager
            .request(entity.url, method: .get, parameters: params ?? [:])
            .nwc_validate()
    }
}

extension DataRequest {
    func nwc_validate() -> Self {
        var allowedStatuses = Array<Int>(200..<300)
        allowedStatuses.append(contentsOf: 400..<423)
        return self.validate(statusCode: allowedStatuses)
    }
    
    var nwc_asCancellable: Cancellable {
        return AlamofireRequestWrap(request: self)
    }
    
    class AlamofireRequestWrap: Cancellable {
        let request: DataRequest
        init(request: DataRequest) {
            self.request = request
        }
        func cancel() {
            request.cancel()
        }
    }
}
