//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/15.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData

final class BookFactory{
    static var instance: BookFactory?
    // var app: AppDelegate?
    var repository: Repository<Books>
    private init(_ app: AppDelegate) {
        repository = Repository<Books>(app)
    }
    static func getInstance(_ app: AppDelegate)-> BookFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.book"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    func getAllBooks() throws -> [Books] {
        return try repository.get()
    }
    
    
    func getBooksOf(category id:UUID )throws -> [Books] {
        return try repository.getKeyWord([Books.colId], keyword: id.uuidString)
    }
    
    func getBookBy(id:UUID)throws -> Books? {
        let books = try repository.getKeyWord([Books.colId], keyword: id.uuidString)
        if books.count > 0  {
            return books[0]
        }
        return nil
        
    }
    func isBookExists(book:Books)throws -> Bool {
        var match10 =  false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0 {
                match10 = try repository.isEntityExists([Books.colIsbn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0 {
                match13 = try repository.isEntityExists([Books.colIsbn13], keyword: isbn13)
            }
        }
        return match13 || match10
    }
    
    ///搜索
    func searchBooks(keyword: String )throws -> [Books] {
        let cols = [Books.colIsbn10,Books.colTitle,Books.colAuthor,
                    Books.colPublisher,Books.colSummary]
        let books = try repository.getKeyWord(cols, keyword: keyword)
        return books
    }
    
    
    ///添加
    func addBooks(book: Books) -> (Bool,String?) {
        do{
            if try repository.isEntityExists([Books.colAuthor], keyword: book.author!) {
                return (false,"同样的书名已存在")
            }
            repository.insert(vm: book)
            return (true,nil)
        }catch DataError.entityExistsError(let info) {
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
        
    }
    
    
    
}
extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once2(token: String, block: () -> Void) {
        
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
