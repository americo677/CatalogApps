//
//  CDAppInfo+CoreDataProperties.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 23/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension CDAppInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAppInfo> {
        return NSFetchRequest<CDAppInfo>(entityName: "CDAppInfo")
    }

    @NSManaged public var idn: String?
    @NSManaged public var title: String?
    @NSManaged public var headerTitle: String?
    @NSManaged public var detail: String?
    @NSManaged public var category: String?
    @NSManaged public var image: NSData?
    @NSManaged public var imageurl: String?

}
