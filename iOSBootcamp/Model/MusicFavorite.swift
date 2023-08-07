//
//  MusicFavorite.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/25.
//

import Foundation
import CoreData

public class MusicFavorite: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicFavorite> {
        return NSFetchRequest<MusicFavorite>(entityName: "MusicFavorite")
    }
    
    @NSManaged public var trackId: Int
    @NSManaged public var trackName: String
    @NSManaged public var artistName: String
    @NSManaged public var trackdescription: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var artworkUrl100: URL
    
}
