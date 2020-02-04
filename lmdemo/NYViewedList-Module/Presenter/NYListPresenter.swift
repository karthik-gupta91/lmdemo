//
//  NYListPresenter.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation

protocol NYLViewToNYLPresenterProtocol: class {
    func fetchArticles(for period: String)
    func showDetailVC(_ article: Article)
}

protocol NYLInteractorToNYLPresenterProtocol: class {
    func FetchSuccess(_ articles:[Article])
    func FetchFailed(_ error: APIResponseError)
}

class NYListPresenter: NYLViewToNYLPresenterProtocol {
    
    weak var view: NYLPresenterToNYLViewProtocol?
    var interactor: NYLPresenterToNYLInteractorProtocol?
    var router: NYLPresenterToNYLRouterProtocol?
        
    func fetchArticles(for period: String) {
        interactor?.fetchData(period)
    }
    
    func showDetailVC(_ article: Article) {
        router?.pushToDetailScreen(article)
    }
    
}

extension NYListPresenter: NYLInteractorToNYLPresenterProtocol {
    func FetchSuccess(_ articles: [Article]) {
        view?.showArticleList(articles)
    }
    
    func FetchFailed(_ error: APIResponseError) {
        switch error {
        case .jsonConversionFailure:
            view?.showError(AppError.decodingError)
        default:
            view?.showError(AppError.networkError)
        }
    }
}
