//
//  AppInfo.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 22/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class AppInfo {
    var _idn: String!
    var _icon: Data!
    var _title: String!
    var _headerTitle: String!
    var _description: String!
    var _category: String!
    var _iconurl: String!
    
    var idn: String {
        
        if _idn == nil {
           _idn = ""
        }
        return _idn
    }
    
    var iconurl: String {
        if _iconurl == nil {
            _iconurl = ""
        }
        return _iconurl
    }
    
    var icon: Data? {
        if _iconurl == nil {
            _icon = nil
        }
        return _icon
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        return _title
    }
    
    var headerTitle: String {
        if _headerTitle == nil {
            _headerTitle = ""
        }
        return _headerTitle
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var category: String {
        if _category == nil {
            _category = Global.NO_CATEGORY
        }
        return _category
    }
    
    init() {
        _idn = nil
        _icon = nil
        _category = nil
        _description = nil
        _title = nil
        _headerTitle = nil
    }
    
}
