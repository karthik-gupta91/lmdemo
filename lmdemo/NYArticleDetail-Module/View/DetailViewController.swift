//
//  DetailViewController.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var article: Article!
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = article.title
        view.addSubview(textView)
        textView.pin(to: view)
        textView.text = article.abstract
        // Do any additional setup after loading the view.
    }
    
    init(_ article: Article) {
        super.init(nibName: nil, bundle: nil)
        self.article = article
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
