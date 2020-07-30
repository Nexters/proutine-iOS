//
//  ViewModelBindableType.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
