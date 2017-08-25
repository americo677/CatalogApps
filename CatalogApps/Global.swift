//
//  Global.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 22/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit

public class Global {
    
    static let JSON_URL = "https://www.reddit.com/reddits.json"
    
    static let NO_CATEGORY = "No Category"
    
    static let SEGUE_IPHONE = "segueIPhone"
    
    static let SEGUE_IPAD = "segueIPad"
    
    static let SEGUE_APP_DETAIL = "segueAppDetail"
    
    static let ROW_HEIGHT_APPS_CELL: CGFloat = 60.0
    
    static let CORNER_RADIUS_FOR_ICON: CGFloat = 10.0
    
    
    struct AppUtility {
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            
            self.lockOrientation(orientation)
            
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
        
    }
    
}
