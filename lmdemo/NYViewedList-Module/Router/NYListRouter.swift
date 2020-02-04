//
//  NYListRouter.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation
import UIKit

protocol NYLPresenterToNYLRouterProtocol: class {
    func pushToDetailScreen(_ article: Article)
}

class NYListRouter:NYLPresenterToNYLRouterProtocol {
    
    var sourceVC: UIViewController!
    
    init(_ sourceVC: UIViewController) {
        self.sourceVC = sourceVC
    }
    
    func pushToDetailScreen(_ article: Article) {
        let vc = DetailViewController(article)
        self.sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
