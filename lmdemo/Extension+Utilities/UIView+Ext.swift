//
//  UIView+Ext.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(to superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
