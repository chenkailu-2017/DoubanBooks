//
//  Repository.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/15.
//  Copyright © 2019年 ckl. All rights reserved.
//

import CoreData
import Foundation
class Repository <T: DataViewModelDelegate> where T: NSObject{
    var app: AppDelegate
    var context : NSManagedObjectContext
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: T) {
        let description = NSEntityDescription.entity(forEntityName:T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key,value) in vm.entityPairs(){
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    
    func isEntityExists(_ cols: [String],keyword:String)throws ->Bool {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("读取集合数据失败")
        }
    }
    ///从本地数据库获取某一实体类全部数据
    ///
    ///- returns:  视图模型对象集合
    func get()throws -> [T]{
        var t = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do{
            let result = try context.fetch(fetch)
            for i in result {
                let vm = T()
                vm.packageSelf(result: i as! NSManagedObject)
                t.append(vm)
            }
            return t
        } catch {
            throw DataError.reanCollectionError("读取集合数据失败")
        }
    }
    ///根据关键词查询某一实体类符合条件的数据，模糊查询
    ///
    /// - parameter cols: 需要匹配的例如：["name","publuisher"]
    /// - parameter keyword:  要搜索的关键词
    /// - returns:  视图模型对象集合
    func getKeyWord(_ cols: [String],keyword:String)throws ->[T]{
        var format = ""
        var args = [String]()
        for col in  cols{
            format += "\(col) like[c] %@ || "
            args.append("*\(keyword)*")
        }
        format.removeLast(3)
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            for i in result {
                let vm = T()
                vm.packageSelf(result: i as! NSManagedObject)
                items.append(vm)
            }
            return items
        } catch {
            throw DataError.reanCollectionError("查询数据失败")
        }
    }
    ///删除数据
    ///
    /// - prameter id: 要删除的id
    func delete(id:UUID)throws  {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do{
            let result = try context.fetch(fetch)
            for m in result {
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        }catch{
            throw DataError.deleteEntityError("删除图书失败")
        }
        
    }
    
    func update(vm:T) throws  {
        let  fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@",vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for (key,value) in vm.entityPairs(){
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        }catch{
            throw DataError.updateEntityError("更新图书失败")
        }
    }
    
}
