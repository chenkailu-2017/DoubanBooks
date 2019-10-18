//
//  Category+CoreDataProperties.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/12.
//  Copyright © 2019年 ckl. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var name: String?

}
