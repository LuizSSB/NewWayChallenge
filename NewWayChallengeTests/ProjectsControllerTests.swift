//
//  ProjectsControllerTests.swift
//  NewWayChallengeTests
//
//  Created by Luiz SSB on 4/26/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import XCTest
@testable import NewWayChallenge

class ProjectsControllerTests: XCTestCase {
    static let numberOfTries = 3
    
    var controllerUnderTest: ProjectsController!
    var mockServiceClient: MockServiceClient!
    
    override func setUp() {
        super.setUp()
        ServiceClientFactory.defaultClientType = .mockUp
        mockServiceClient = ServiceClientFactory.acquireServiceClient()
            as! MockServiceClient
    }
    
    override func tearDown() {
        mockServiceClient = nil
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testDataAcquisition() {
        var timesGotten = 0
        mockServiceClient.returnedElements = ProjectsController.recordsPerPage
        
        let promise = expectation(description: "got entries 3 times")
        controllerUnderTest = ProjectsController(
            language: AlamofireServiceClientTests.invalidLanguage
        )
        let delegate = ProjectsControllerBlockDelegate(
            willGet: { _ in },
            didGet: { [unowned self] c, rs in
                switch timesGotten {
                case 0:
                    XCTAssert(
                        c.acquisitionIndex != Int.max && c.acquisitionIndex > 0
                    )
                    XCTAssert(
                        c.count == ProjectsController.recordsPerPage &&
                            c.hasMore
                    )
                    XCTAssert(c[0].name == rs[0].name)
                    
                    let index = c.acquisitionIndex - 1
                    XCTAssert(c[index].name == rs[index].name)
                    XCTAssert(c[c.count - 1].name == rs.last!.name)
                    XCTAssert(c.acquisitionIndex == Int.max)
                    
                case 1:
                    XCTAssert(
                        c.count == ProjectsController.recordsPerPage * 2 &&
                            c.hasMore
                    )
                    XCTAssert(
                        c.count == rs.count + ProjectsController.recordsPerPage
                    )
                    XCTAssert(c[c.count - rs.count].name == rs[0].name)
                    
                    let index = c.acquisitionIndex - 1
                    XCTAssert(c[index].name == rs[c.count - index - 2].name)
                    
                    self.mockServiceClient.returnedElements = 1
                    XCTAssert(c[c.count - 1].name == rs.last!.name)
                    XCTAssert(c.acquisitionIndex == Int.max)
                    
                case 2:
                    XCTAssert(
                        c.count == ProjectsController.recordsPerPage * 2 + 1 &&
                            !c.hasMore
                    )
                    XCTAssert(c.acquisitionIndex == Int.max)
                    XCTAssert(
                        c.count ==
                            rs.count + ProjectsController.recordsPerPage * 2
                    )
                    promise.fulfill()
                    
                default:
                    XCTFail("test not meant to get data more than 3 times")
                }
                
                timesGotten += 1
            },
            didFail: { c, e in }
        )
        
        controllerUnderTest.delegate = delegate
        controllerUnderTest.start()
        
        waitForExpectations(
            timeout: AlamofireServiceClientTests.needslesslyLongTimeout *
                TimeInterval(ProjectsControllerTests.numberOfTries),
            handler: nil
        )
    }
    
    // MARK: - Projects Controller Delegate
    
    class ProjectsControllerBlockDelegate: ProjectsControllerDelegate {
        let willGet: (ProjectsController) -> ()
        let didGet: (ProjectsController, [Repository]) -> ()
        let didFail: (ProjectsController, ResponseError) -> ()
        
        init(
            willGet: @escaping (ProjectsController) -> (),
            didGet: @escaping (ProjectsController, [Repository]) -> (),
            didFail:  @escaping (ProjectsController, ResponseError) -> ()
        ) {
            self.willGet = willGet
            self.didGet = didGet
            self.didFail = didFail
        }
        
        func projecControllerWillGetEntries(_ controller: ProjectsController) {
            willGet(controller)
        }
        func projectController(
            _ controller: ProjectsController, didGetEntries entries: [Repository]
            ) {
            didGet(controller, entries)
        }
        func projectController(
            _ controller: ProjectsController, didFail error: ResponseError
            ) {
            didFail(controller, error)
        }
    }
}
