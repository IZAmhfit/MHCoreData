//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit


///
///
///
public extension UIViewController {
    //
    func embedInNav() -> UINavigationController {
        //
        UINavigationController(rootViewController: self)
    }
    
    //
    var isVisible: Bool {
        //
        return isViewLoaded && (view.window != nil)
    }
}

///
///
///
public extension UINavigationController {
    //
    func add(tabBarItem title: String, tag: Int, image: UIImage? = nil)
    {
        //
        tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
    }
}

