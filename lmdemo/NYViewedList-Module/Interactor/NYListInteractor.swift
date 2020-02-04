//
//  NYListInteractor.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation

protocol NYLPresenterToNYLInteractorProtocol: class {
    func fetchData(_ period: String)
}

class NYListInterator: NYLPresenterToNYLInteractorProtocol {
    
    var remoteClient: RemoteClientProtocol!
    
    private weak var presenter: NYLInteractorToNYLPresenterProtocol!
    
    init(_ presenter:NYLInteractorToNYLPresenterProtocol, _ remoteClient: RemoteClientProtocol) {
        self.presenter = presenter
        self.remoteClient = remoteClient
    }
        
    func fetchData(_ period: String) {
        remoteClient.query = "\(period).json"
        remoteClient.queryItems = [URLQueryItem(name: "api-key", value: "ApLDuAA2nFWc1hmAHDzcwCzByM1YH8Xv")]
        remoteClient.fetch(with: ApiResource.mostViewed.urlComponent, httpMethod: ApiResource.mostViewed.httpMethod, decodingType: NYViewedModel.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.presenter.FetchSuccess(list.results)
            case.failure(let error):
                self.presenter.FetchFailed(error)
            }
        }
    }
}



