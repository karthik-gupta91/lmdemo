//
//  lmdemoTests.swift
//  lmdemoTests
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import XCTest
@testable import lmdemo

class lmdemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

class MockNYLVC: UIViewController, NYLPresenterToNYLViewProtocol {

    var inputCallbackResults = [String:String]()
    var presenter: NYLViewToNYLPresenterProtocol!
    
    init(_ presenter: NYLViewToNYLPresenterProtocol ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showArticleList(_ articles: [Article]) {
        if articles.count > 0 {
            inputCallbackResults["ArticleFetched"] = "true"
        } else {
            inputCallbackResults["ArticleFetched"] = "false"
        }
        
    }
    
    func showError(_ error: AppError) {
        inputCallbackResults["Error"] = error.errorDescription
    }
}

class MockNYLPresenter: NYLViewToNYLPresenterProtocol, NYLInteractorToNYLPresenterProtocol {
    
    weak var view: NYLPresenterToNYLViewProtocol?
    var interactor: NYLPresenterToNYLInteractorProtocol?
    var router: NYLPresenterToNYLRouterProtocol?
    var inputCallbackResults = [String:String]()
    var list:[Article] = []
    var refreshData:Bool = false
    
    func fetchArticles(for period: String) {
    }
    
    func FetchSuccess(_ articles: [Article]) {
        inputCallbackResults["id"] = "\(articles[0].id)"
    }
    
    func FetchFailed(_ error: APIResponseError) {
        inputCallbackResults["Error"] = error.errorDescription
    }
    
    func showDetailVC(_ article: Article) {
    }
}

class MockNYLInteractor: NYLPresenterToNYLInteractorProtocol {
    var presenter: NYLInteractorToNYLPresenterProtocol!
    init(_ presenter: NYLInteractorToNYLPresenterProtocol) {
        self.presenter = presenter
    }
    
    var list: [Article] = []
    var error: APIResponseError?
    
    func fetchData(_ period: String) {
        if let error = error {
            presenter.FetchFailed(error)
        } else {
            presenter.FetchSuccess(list)
        }
    }
}

class MockNYLRouter: NYLPresenterToNYLRouterProtocol {
    var inputCallbackResults = [String:String]()
    
    func pushToDetailScreen(_ article: Article) {
        inputCallbackResults["ShowDetailVC"] = "true"
    }
}

class MockNYLRemoteClient: RemoteClientProtocol {
    var query: String?
    var queryItems: [URLQueryItem]?
    var params: [String : Any]?
    var headers: [String : String]?
    var session: URLSession!
    
    var error: APIResponseError?
    var model: NYViewedModel?
    
    func fetch<T>(with urlComponent: URLComponents, httpMethod: HTTPMethod, decodingType: T.Type, completion: @escaping (Result<T, APIResponseError>) -> Void) where T : Decodable {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(model as! T))
        }
    }
    
}
