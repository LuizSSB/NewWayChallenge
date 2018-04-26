//
//  ServiceClientFactory.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

enum ServiceClientType {
    case alamofire
    case mockUp
}

class ServiceClientFactory {
    private static let _serviceClient: [ServiceClientType: ServiceClient] = [
        .alamofire: AlamofireServiceClient(),
        .mockUp: MockServiceClient(),
    ]
    
    static let defaultClientType: ServiceClientType = .alamofire
    
    static func acquireServiceClient(
        ofType type: ServiceClientType = ServiceClientFactory.defaultClientType
        ) -> ServiceClient {
        
        guard let client = _serviceClient[type] else {
            fatalError("unknown service client type")
        }
        
        return client
    }
}
