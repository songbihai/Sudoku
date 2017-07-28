//
//  SKRank+CoreDataProperties.swift
//  Sudoku
//
//  Created by 宋碧海 on 2017/7/27.
//  Copyright © 2017年 songbihai. All rights reserved.
//

import Foundation
import CoreData


extension SKRank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SKRank> {
        return NSFetchRequest<SKRank>(entityName: "SKRank")
    }

    @NSManaged public var name: String?
    @NSManaged public var level: String?
    @NSManaged public var seconds: Int64
    @NSManaged public var time: String?

}
