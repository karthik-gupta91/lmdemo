//
//  NYListInteractorTests.swift
//  lmdemoTests
//
//  Created by kartik on 04/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import XCTest
@testable import lmdemo

class NYListInteractorTests: XCTestCase {

    private var presenter: MockNYLPresenter!
    private var remoteClient: MockNYLRemoteClient!
    var interactor: NYListInterator!
    
    override func setUp() {
        presenter = MockNYLPresenter()
        remoteClient = MockNYLRemoteClient()
        interactor = NYListInterator(presenter, remoteClient)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchDataWhenError() {
        remoteClient.error = APIResponseError.requestFailed
        interactor.fetchData("1")
        XCTAssertTrue(presenter.inputCallbackResults["Error"] == APIResponseError.requestFailed.errorDescription)
    }

    func testFetchData() {
        remoteClient.model = NYViewedModel(status: "", copyright: "", numResults: 10, results: [TestUtility.mockInfo(101)])
        interactor.fetchData("1")
        XCTAssertTrue(presenter.inputCallbackResults["id"] == "101")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
