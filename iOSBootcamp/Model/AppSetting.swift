//
//  AppSetting.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/20.
//

import CoreData

public class AppSetting: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSetting> {
        return NSFetchRequest<AppSetting>(entityName: "AppSetting")
    }
    @NSManaged public var darkmode: String
}
