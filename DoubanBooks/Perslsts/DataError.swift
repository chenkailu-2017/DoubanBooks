//
//  DataError.swift
//  DoubanBooks
//
//  Created by chen on 2019/10/12.
//  Copyright © 2019年 ckl. All rights reserved.
//

import Foundation
enum DataError: Error{
    case reanCollectionError(String)
    case readSingleError(String)
    case entityExistsError(String)
    case deleteEntityError(String)
    case updateEntityError(String)}
 
