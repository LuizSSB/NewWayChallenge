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
    func setup() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    func getRepositories(
        of language: String, page: Int, sortedBy sortFields: [String]?,
        callback: @escaping ArrayServiceCallback<Repository>
    ) -> Cancellable {
        var params: Parameters = [
            "q": "language:" + language,
            "page": page
        ]
        if let sortFields = sortFields {
            params["sort"] = sortFields.joined(separator: ",")
        }
        
        return AlamofireServiceClient.GETRequest(for: Repository.self, params: params)
            .responseObject { (response: DataResponse<RepositoriesQueryResponse>) in
                if let result = response.result.value {
                    callback(result.items, result.mainError)
                } else {
                    callback(nil, ResponseError.generic);
                }
            }
            .nwc_asCancellable
    }
    
    private static func GETRequest<T: QueryableEntity> (
        for entity: T.Type, params: [String: Any]?
    ) -> DataRequest {
        return Alamofire
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
