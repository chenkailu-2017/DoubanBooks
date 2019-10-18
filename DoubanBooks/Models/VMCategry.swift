//
//  VMCategry.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/12.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData
class VMCategry:NSObject,DataViewModelDelegate{
    
    
    var id:UUID
    var name:String?
    var image:String?
    
//    init(name:String,image:String){
//        self.id = UUID()
//        self.name = name
//        self.image = image
//    }
    override init(){
        self.id = UUID()
    }
    static let entityName = "Category"
    static let coId = "id"
    static let colName = "name"
    static let colImage = "image"
    
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dic:Dictionary<String, Any?> = Dictionary<String, Any?>()
        dic[VMCategry.coId] = id
        dic[VMCategry.colName] = name
        dic[VMCategry.colImage] = image
        return dic
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let category = result as! Category
        id = category.id!
        image = category.image
        name = category.name
    }
}
