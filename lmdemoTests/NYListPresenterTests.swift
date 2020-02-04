//
//  NYListPresenterTests.swift
//  lmdemoTests
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import XCTest
@testable import lmdemo

class NYListPresenterTests: XCTestCase {

    var presenter: NYListPresenter!
    var view: NYLPresenterToNYLViewProtocol!
    var interactor: MockNYLInteractor!
    var router: MockNYLRouter!
    var viewController : MockNYLVC!

    override func setUp() {
        presenter = NYListPresenter()
        
        viewController = MockNYLVC(presenter)
        interactor = MockNYLInteractor(presenter)
        router = MockNYLRouter()
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        viewController.presenter = presenter
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testFetchArticlesWhenJsonConversionFailed() {
        interactor.error = APIResponseError.jsonConversionFailure
        presenter.fetchArticles(for: "1")
        XCTAssertTrue(viewController.inputCallbackResults["Error"] == "\(AppError.decodingError.errorDescription)")
        
    }
    
    func testFetchArticlesWhenNetworkErrorOccured() {
        interactor.error = APIResponseError.requestFailed
        presenter.fetchArticles(for: "1")
        XCTAssertTrue(viewController.inputCallbackResults["Error"] == "\(AppError.networkError.errorDescription)")
        
    }
    
    func testFetchArticlesWhenReturnEmptyData() {
        presenter.fetchArticles(for: "1")
        XCTAssertTrue(viewController.inputCallbackResults["ArticleFetched"] == "false")
        
    }
    
    func testFetchArticles() {
        interactor.list = [TestUtility.mockInfo(1)]
        presenter.fetchArticles(for: "1")
        XCTAssertTrue(viewController.inputCallbackResults["ArticleFetched"] == "true")
        
    }
    
    func testPushToDetailVC()  {
        presenter.showDetailVC(TestUtility.mockInfo(1))
        XCTAssertTrue(router.inputCallbackResults["ShowDetailVC"] == "true")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

struct TestUtility {
    static func mockInfo(_ id:Int) -> Article {
        return Article(url: "", adxKeywords: "", column: "", section: "", byline: "", type: .article, title: "", abstract: "", publishedDate: "", source: .theNewYorkTimes, id: id, assetID: 1, views: 1, desFacet: [""], orgFacet: .string(""), perFacet: .string(""), geoFacet: .string(""), media: [.init(type: .image, subtype: .photo, caption: "", copyright: "", approvedForSyndication: 1, mediaMetadata: [.init(url: "", format: .mediumThreeByTwo210, height: 1, width: 1)])], uri: "")
    }
}
