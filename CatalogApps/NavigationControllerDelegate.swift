//
//  NavigationControllerDelegate.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 25/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation:
        UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        let animation = CustomNavigationAnimationController()
        
        animation.reverse = operation == .pop
        
        return animation
    }
}
