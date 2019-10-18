//
//  Books.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/14.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
import CoreData
class Books:NSObject,DataViewModelDelegate{
    
    
    var id:UUID
    var categoryId:UUID?
    var title:String?
    var author:String?
    var isbn10:String?
    var isbn13:String?
    var publisher:String?
    var pubdate:String?
    var summary:String?
    var page:Int32?
    var price:Float?
    var image:String?
    var autorINtro:String?
    var binding:String?
    
//    init(title:String,author:String,isbn10:String,isbn13:String,publisher:String,pubdate:String,summary:String,page:Int32,image:String,autorINtro:String,price:Float,binding:String){
//        self.id=UUID()
//        self.categoryId=UUID()
//        self.title=title
//        self.author=author
//        self.isbn10=isbn10
//        self.isbn13=isbn13
//        self.publisher=publisher
//        self.pubdate=pubdate
//        self.summary=summary
//        self.page=page
//        self.image=image
//        self.autorINtro=autorINtro
//        self.price=price
//        self.binding=binding
//    }
    
    override init(){
        self.id=UUID()
       
    }
    static let entityName = "Book"
    
    
    static let colcategoryId = "categoryId"
    static let colId = "id"
    static let colTitle = "title"
    static let colAuthor = "author"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colPublisher = "publisher"
    static let colPubdate = "pubdate"
    static let colSummary = "summary"
    static let colPage = "page"
    static let colImage = "image"
    static let colAutorINtro = "autorINtro"
    static let colPrice = "price"
    static let colBinding = "binding"
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dic:Dictionary<String, Any?> = Dictionary<String, Any?>()
        dic[Books.colId] = id
        dic[Books.colcategoryId] = categoryId
        dic[Books.colImage] = image
        dic[Books.colPage] = page
        dic[Books.colPrice] = price
        dic[Books.colPubdate] = pubdate
        dic[Books.colPublisher] = publisher
        dic[Books.colTitle] = title
        dic[Books.colIsbn10] = isbn10
        dic[Books.colIsbn13] = isbn13
        dic[Books.colSummary] = summary
        dic[Books.colBinding] = binding
        dic[Books.colAutorINtro] = autorINtro
        dic[Books.colAuthor] = author
        
        return dic
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let category = result as! Book
        id = category.id!
        image = category.image
        categoryId = category.categoryId
        page = category.page
        publisher = category.publisher
        pubdate = category.pubdate
        price = category.price
        title = category.title
        isbn10 = category.isbn10
        isbn13 = category.isbn13
        summary = category.summary
        binding = category.binding
        autorINtro = category.autorIntro
        author = category.author
        
        
        
    }
    
}
