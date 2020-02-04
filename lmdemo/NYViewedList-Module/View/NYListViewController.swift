//
//  ViewController.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import UIKit

protocol NYLPresenterToNYLViewProtocol: class {
    func showArticleList(_ articles: [Article])
    func showError(_ error: AppError)
}

class NYListViewController: UIViewController {

    private var period: Int = 1
    private lazy var articles: [Article] = []
    private var presenter: NYLViewToNYLPresenterProtocol!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let refreshControl = UIRefreshControl()
    init(_ presenter: NYLViewToNYLPresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ListTableCell", bundle: .main), forCellReuseIdentifier: "ListTableCell")
        tableview.tableFooterView = activityIndicator
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Latest Articles"
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.pin(to: view)
        configureRefreshControl()
        fetchData()
        // Do any additional setup after loading the view.
    }

    func fetchData() {
        activityIndicator.startAnimating()
        presenter.fetchArticles(for: "\(period)")
    }
    
    private func configureRefreshControl() {
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefreshData), for: .valueChanged)
    }
    
    @objc private func pullToRefreshData() {
        fetchData()
    }
}

extension NYListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListTableCell {
            cell.accessoryType = .disclosureIndicator
            cell.setCell(article: articles[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showDetailVC(articles[indexPath.row])
    }
}

extension NYListViewController: NYLPresenterToNYLViewProtocol {
    func showArticleList(_ articles: [Article]) {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        self.articles = articles
        tableview.reloadData()
    }
    
    func showError(_ error: AppError) {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let refreshAction = UIAlertAction(title: "Try again", style: .default) { _ in
            self.fetchData()
        }
        alert.addAction(okAction)
        alert.addAction(refreshAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
