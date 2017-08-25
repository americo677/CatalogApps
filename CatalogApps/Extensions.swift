//
//  Extensions.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 23/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Alerta personalizada
    func showCustomAlert(_ vcSelf: UIViewController!, titleApp: String, strMensaje: String, toFocus: UITextField?) {
        let alertController = UIAlertController(title: titleApp, message:
            strMensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.cancel,handler: {_ in
            
            if toFocus != nil {
                toFocus!.becomeFirstResponder()
            }
        }
        )
        
        alertController.addAction(action)
        
        vcSelf.present(alertController, animated: true, completion: nil)
        
    }
}

extension UIDevice {
    
    var device: String {
        
        var systemInfo = utsname()
        
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0
            else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
}

