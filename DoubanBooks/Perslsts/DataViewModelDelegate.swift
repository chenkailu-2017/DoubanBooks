//
//  DataViewModelDelegate.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/15.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData

protocol  DataViewModelDelegate {
    ///视图模型必须具有id属性
    var id: UUID {get}
    ///试图模型对应的CoreData Entity的名称
    static var entityName: String {get}
    ///CoreData Entity 属性与对应的视图模型对象的属性值集合
    func entityPairs() -> Dictionary<String,Any?>
    ///根据查询结果组装视图模型对象
    
    ///parameter result： fetch方法查询结果
    func packageSelf(result:NSFetchRequestResult)
}
