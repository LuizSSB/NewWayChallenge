//
//  AlamofireServiceClientTests.swift
//  NewWayChallengeTests
//
//  Created by Luiz SSB on 4/26/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import XCTest
@testable import NewWayChallenge

class AlamofireServiceClientTests: XCTestCase {
    static let validLanguage = "Swift"
    static let invalidLanguage = "Foobar"
    
    static let inBoundsPage = 2
    static let outOfBoundsPage = 43
    static let invalidPage = 0
    static let expectedNumberOfResults = 30
    
    static let needslesslyLongTimeout: TimeInterval = 11
    
    var clientUnderTest: AlamofireServiceClient!
    
    override func setUp() {
        super.setUp()
        clientUnderTest = AlamofireServiceClient()
        clientUnderTest.setup()
    }
    
    override func tearDown() {
        clientUnderTest = nil
        super.tearDown()
    }
    
    func testQueryRepositories_cancelling() {
        expectation(description: "cancelled request finished").isInverted = true
        
        clientUnderTest.getRepositories(
            of: AlamofireServiceClientTests.validLanguage,
            page: AlamofireServiceClientTests.inBoundsPage,
            sortedBy: nil
        ) { _, _ in
            XCTFail("Cancelled request called callback")
        }.cancel()
        
        waitForExpectations(
            timeout: AlamofireServiceClientTests.needslesslyLongTimeout,
            handler: nil
        )
    }
    
    func testQueryRepositories_requestValidation() {
        let validPromise = expectation(description: "valid request")
        _ = clientUnderTest.getRepositories(
            of: AlamofireServiceClientTests.validLanguage,
            page: AlamofireServiceClientTests.inBoundsPage, sortedBy: nil
        ) { _, error in
            guard error == nil else {
                XCTFail("Valid request failed")
                return
            }
            
            validPromise.fulfill()
        }
        
        let languagePromise = expectation(description: "invalid language request")
        _ = clientUnderTest.getRepositories(
            of: AlamofireServiceClientTests.invalidLanguage,
            page: AlamofireServiceClientTests.inBoundsPage, sortedBy: nil
        ) { _, error in
            guard let error = error else {
                XCTFail("Invalid language request returned results")
                return
            }
            
            guard error.code == .invalid else {
                XCTFail("Invalid language request triggered wrong error")
                return
            }
            
            languagePromise.fulfill()
        }
        
        let pagePromise = expectation(description: "invalid page request")
        _ = clientUnderTest.getRepositories(
            of: AlamofireServiceClientTests.validLanguage,
            page: AlamofireServiceClientTests.invalidPage, sortedBy: nil
        ) { _, error in
            guard let error = error else {
                XCTFail("Invalid page request returned results")
                return
            }
            
            guard error.code == .invalid else {
                XCTFail("Invalid page request triggered wrong error")
                return
            }
            
            pagePromise.fulfill()
        }
        
        waitForExpectations(
            timeout: AlamofireServiceClientTests.needslesslyLongTimeout,
            handler: nil
        )
    }
    
    func testQueryRepositories_paging() {
        let inBoundsPromise = expectation(description: "in bounds request")
        _ = clientUnderTest.getRepositories(
            of: AlamofireServiceClientTests.validLanguage,
            page: AlamofireServiceClientTests.inBoundsPage, sortedBy: nil
        ) { items, error in
            guard error == nil else {
                XCTFail("in bounds request returned results")
                return
            }
            
            guard let items = items,
                items.count == AlamofireServiceClientTests.expectedNumberOfResults
                else {
                    XCTFail("in bounds request did not return the expected number of results")
                    return
                }
            
            inBoundsPromise.fulfill()
        }
        
        waitForExpectations(
            timeout: AlamofireServiceClientTests.needslesslyLongTimeout,
            handler: nil
        )
    }
}
