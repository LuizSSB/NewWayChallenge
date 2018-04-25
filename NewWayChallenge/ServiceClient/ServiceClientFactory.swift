//
//  ServiceClientFactory.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation

class ServiceClientFactory {
    private static let _serviceClient = AlamofireServiceClient()
    
    static func acquireServiceClient() -> ServiceClient {
        return _serviceClient
    }
}
