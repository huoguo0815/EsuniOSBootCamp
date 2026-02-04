//
//  NavigationController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/20.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if mode == "light" {
            UIApplication.shared.statusBarStyle = .lightContent
            return topViewController?.preferredStatusBarStyle ?? .lightContent
        } else if mode == "dark" {
            UIApplication.shared.statusBarStyle = .darkContent
            return topViewController?.preferredStatusBarStyle ?? .darkContent
        } else {
            return topViewController?.preferredStatusBarStyle ?? .default
            
        }
    }

}
