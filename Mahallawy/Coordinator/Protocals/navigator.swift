//
//  navigator.swift
//  Opportunities
//
//  Created by youssef on 12/9/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit

enum NavigationType {
    case push
    case present
    case root
}

protocol Navigator {
    associatedtype Destination
    func viewController(for destination : Destination) -> UIViewController
    init(coordintor : Coordinator)
    var coordinator : Coordinator {get}
    func Navigate(to destination : Destination, With navigationType : NavigationType)
}

extension Navigator {
   
    func Navigate(to destination : Destination, With navigationType : NavigationType = .push) {
        let viewController = self.viewController(for: destination)
        print(viewController)
        switch navigationType {
        case .push:
              coordinator.navigationController?.pushViewController(viewController, animated: true)
        case .present:
            coordinator.navigationController?.present(viewController, animated: true)
        case .root:
              coordinator.navigationController?.setViewControllers([viewController], animated: true)
        }
    }
}
