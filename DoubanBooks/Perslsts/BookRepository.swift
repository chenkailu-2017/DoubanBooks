//
//  BookRepository.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/15.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData
class BookRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    func insert(vm: Books) {
        let description = NSEntityDescription.entity(forEntityName: Books.entityName, in: context)
        let category = NSManagedObject(entity: description!,insertInto: context)
        category.setValue(vm.id, forKey: Books.colId)
        category.setValue(vm.image, forKey: Books.colImage)
        category.setValue(vm.author, forKey: Books.colAuthor)
        category.setValue(vm.autorINtro, forKey: Books.colAutorINtro)
        category.setValue(vm.categoryId, forKey: Books.colcategoryId)
        category.setValue(vm.isbn10, forKey: Books.colIsbn10)
        category.setValue(vm.isbn13, forKey: Books.colIsbn13)
        category.setValue(vm.publisher, forKey: Books.colPublisher)
        category.setValue(vm.page, forKey: Books.colPage)
        category.setValue(vm.pubdate, forKey: Books.colPubdate)
        category.setValue(vm.price, forKey: Books.colPrice)
        category.setValue(vm.summary, forKey: Books.colSummary)
        category.setValue(vm.title, forKey: Books.colTitle)
        category.setValue(vm.binding, forKey: Books.colBinding)
        app.saveContext()
    }
    func isExists(name:String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Books.entityName)
        fetch.predicate = NSPredicate(format: "\(Books.colcategoryId) =%@",name)
        do{
            let result = try context.fetch(fetch) as! [Books]
            return result.count > 0
        }catch{
            throw DataError.entityExistsError("判断数据2失败")
        }
    }
    //搜索
    func getBook() throws -> [Books] {
        var book = [Books]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Books.entityName)
        do{
            let result = try context.fetch(fetch) as! [Books]
            for c in result {
                
                let vm = Books()
                
                vm.id = c.id
                vm.categoryId = c.categoryId
                vm.image = c.image
                vm.author = c.author
                vm.autorINtro = c.autorINtro
                vm.binding = c.binding
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.page = c.page
                vm.price = c.price
                vm.pubdate = c.pubdate
                vm.publisher = c.publisher
                vm.summary = c.summary
                vm.title = c.title
                
                book.append(vm)
            }
        }
        return book
    }
    
    
    func getBy(keyword format:String,args:[Any])  throws-> [Books] {
        var books = [Books]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Books.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch) as! [Books]
            for c in result{
                let vm = Books()
                vm.id = c.id
                vm.image = c.image
                vm.author = c.author
                books.append(vm)
            }
            return books
        }catch{
            throw DataError.reanCollectionError("读取集合数据失败")
        }
    }
    
    
    func update(vm:Books) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Books.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            obj.setValue(vm.author, forKey: Books.colAuthor)
        }catch{
            throw DataError.updateEntityError("更新图书失败")
        }
    }
    
    //删除
    func delete(id: UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Books.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do{
            let result = try context.fetch(fetch)
            for b in result {
                context.delete(b as! NSManagedObject)
            }
            app.saveContext()
        }catch {
            throw DataError.deleteEntityError("删除图书失败")
        }
    }
}



