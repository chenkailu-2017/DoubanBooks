//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/12.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData
class CategoryRepository{
    var app:AppDelegate
    var context: NSManagedObjectContext
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    //持久化
    func insert(vm: VMCategry) {
        let description = NSEntityDescription.entity(forEntityName: "Category", in: context)
        
        let category = NSManagedObject(entity: description!,insertInto: context)
        category.setValue(vm.id, forKey: VMCategry.coId)
        category.setValue(vm.image, forKey: VMCategry.colImage)
        category.setValue(vm.name, forKey: VMCategry.colName)
        app.saveContext()
        
    }
    
    func isExists(name: String) throws -> Bool{
        let fetch=NSFetchRequest<NSFetchRequestResult>(entityName: VMCategry.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategry.colName)= &@", name)
        do{
            let result = try context.fetch(fetch) as! [VMCategry]
            return result.count > 0
        }catch {
            throw DataError.entityExistsError("数据失败")
        }
        
    }
    
//    func getMovies(keyword:String? = nil) throws -> [VMCategry]{
//        var categorys = [VMCategry]()
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:
//            "Category")
//        if let kw = keyword {
//            //fetch.predicate = NSPredicate(format: "name like[c] %@ || region like[c] %@","*\(kw)*", "*\(kw)*")
//            fetch.predicate = NSPredicate(format: "name like[c] %@", "*\(kw)*")
//        }
//
//        let result = try context.fetch(fetch) as! [Category]
//        for item in result{
//            let vm = VMCategry()
//            vm.id = item.id!
//            vm.image = item.image
//            vm.name = item.name
//
//            categorys.append(vm)
//        }
//        return categorys
//    }
    
    func get() throws ->[VMCategry] {
        var categories = [VMCategry]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategry.entityName)
        do{
            let result = try context.fetch(fetch) as! [VMCategry]
            for c in result{
                let vm = VMCategry()
                vm.id = c.id
                vm.image = c.image
                vm.name = c.name
                categories.append(vm)
            }
        }catch{
            throw DataError.reanCollectionError("读取聚合数据失败")
        }
        return categories
    }
    
//    func delete(id: UUID) throws {
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:
//            "Category")
//        fetch.predicate = NSPredicate(format: "id = %@",
//                                      id.uuidString)
//        let result = try context.fetch(fetch) as! [Category]
//        for m in result {
//            context.delete(m)
//        }
//        app.saveContext()
//    }
}

