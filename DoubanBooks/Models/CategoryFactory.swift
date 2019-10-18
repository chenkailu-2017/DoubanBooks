//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/14.
//  Copyright © 2019年 ckl. All rights reserved.
//

import CoreData
import Foundation
final class CategoryFactory  {
    static var instance: CategoryFactory?
    var app: AppDelegate?
    var repository:Repository<VMCategry>
    private init(_ app: AppDelegate) {
        repository = Repository<VMCategry>(app)
        self.app = app
    }
    static func getInstance(_ app: AppDelegate)-> CategoryFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
            })
            return instance!
        }
    }
    func getAllCategories() throws -> [VMCategry] {
        return try repository.get()
    }
    
    
    func addCategory(category: VMCategry) -> (Bool,String?) {
        do{
            if try repository.isEntityExists([VMCategry.colName],keyword: category.name!) {
                return (false,"同样类别已存在")
            }
            repository.insert(vm: category)
            return (true,nil)
        }catch DataError.entityExistsError(let info) {
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
        
    }
    
    func remove(category: VMCategry) -> (Bool,String?) {
        if  let count = getBooksCountOfCategory(category: category.id){
            if count > 0 {
                return (false, "该图书不存在")
            }
            
        }else{
            return (false, "无法获取类别信息")
        }
        do{
            try repository.delete(id: category.id)
            return (true, nil)
        }catch DataError.entityExistsError(let info) {
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
    func getBooksCountOfCategory(category id: UUID ) -> Int? {
        do{
            return try BookFactory.getInstance(app!).getBooksOf(category:id).count
            
        } catch {
            return nil
        }
        
    }
    
}
extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        
        objc_sync_enter(self)
        
        defer {
            
            objc_sync_exit(self)
            
        }
        
        if _onceTracker.contains(token) {
            
            return
            
        }
        
        _onceTracker.append(token)
        
        block()
        
    }
    
}
