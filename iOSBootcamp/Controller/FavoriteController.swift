//
//  FavoriteController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/25.
//

import Foundation
import CoreData
import UIKit

class FavoriteController: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = FavoriteController()
    
    var musicFavorite: MusicFavorite!
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    
    //Core Data讀取資料
    func fetchFavoriteData() {
        
        let fetchRequest: NSFetchRequest<MusicFavorite> = MusicFavorite.fetchRequest()
        let sortDesriptor = NSSortDescriptor(key: "trackId", ascending: true)
        fetchRequest.sortDescriptors = [sortDesriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
            } catch {
                print("讀取資料出現錯誤\(error)")
            }
        }
    }
    
    func isFavorite(trackId: Int) -> Bool {
        
        fetchFavoriteData()
        
        let fetchRequest: NSFetchRequest<MusicFavorite> = MusicFavorite.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "trackId == %@", NSNumber(value: trackId))
        
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        let context = appDelegate!.persistentContainer.viewContext
           do {
               let matchingTracks = try context.fetch(fetchRequest)
               print("確認為\(matchingTracks.isEmpty)")
               return !matchingTracks.isEmpty
           } catch {
               print("確認失敗 \(error)")
               return false
           }
        
        
    }
    func addToFavorite(trackId: Int, trackName: String, artistName: String, artworkUrl100: URL) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            musicFavorite = MusicFavorite(context: appDelegate.persistentContainer.viewContext)
            
            musicFavorite.setValue(trackId, forKey: "trackId")
            musicFavorite.setValue(trackName, forKey: "trackName")
            musicFavorite.setValue(artistName, forKey: "artistName")
            musicFavorite.setValue(artworkUrl100, forKey: "artworkUrl100")
            musicFavorite.setValue(true, forKey: "isFavorite")
            
            do {
                appDelegate.saveContext()
                print("成功加入收藏")
            } catch let error as NSError {
                print("收藏失敗 \(error), \(error.userInfo)")
            }
        }
        
    }
    func removeFromFavorite() {}
    
    
}


