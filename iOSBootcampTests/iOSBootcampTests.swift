//
//  iOSBootcampTests.swift
//  iOSBootcampTests
//
//  Created by esb23471 on 2023/8/9.
//

import XCTest
@testable import iOSBootcamp
import SafariServices
import CoreData

final class iOSBootcampTests: XCTestCase {
    
    var viewController: SearchViewController!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        viewController.loadViewIfNeeded()
        // 創建模擬的 Core Data 存儲
        mockPersistentContainer = NSPersistentContainer(name: "iOSBootcamp")
        mockPersistentContainer.persistentStoreDescriptions = [NSPersistentStoreDescription()]
        mockPersistentContainer.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        mockPersistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        // 將模擬存儲設置為 FavoriteController 使用的存儲
        FavoriteController.shared.fetchResultController = NSFetchedResultsController(fetchRequest: MusicFavorite.fetchRequest(), managedObjectContext: mockPersistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
    }
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testaddToFavorite() {
        // 初始化 FavoriteController 實例
        let favoriteController = FavoriteController()
        
        // 創建模擬的 Core Data 存儲
        let mockPersistentContainer = NSPersistentContainer(name: "iOSBootcamp")
        mockPersistentContainer.persistentStoreDescriptions = [NSPersistentStoreDescription()]
        mockPersistentContainer.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        mockPersistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }

        // 將模擬存儲設置為 FavoriteController 使用的存儲
        favoriteController.fetchResultController = NSFetchedResultsController(fetchRequest: MusicFavorite.fetchRequest(), managedObjectContext: mockPersistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // 設置 fetchResultController 給 dataSource
        viewController.fetchResultController = favoriteController.fetchResultController
        viewController.dataSource = viewController.configureDataSource()
        
        //添加排序描述符
        let sortDescriptor = NSSortDescriptor(key: "trackId", ascending: true)
        favoriteController.fetchResultController.fetchRequest.sortDescriptors = [sortDescriptor]

        
        // 調用 addToFavorite
        let trackId: Int64 = 123
        favoriteController.addToFavorite(
            trackId: Int(trackId),
            trackName: "Test Track",
            artistName: "Test Artist",
            trackdescription: "Test Description",
            artworkUrl100: URL(string: "http://test.com/image.png")!,
            kind: "music",
            trackViewUrl: URL(string: "http://test.com/track")!,
            collectionName: "Test Collection",
            trackTime: "3:45"
        )

        // 驗證是否成功添加到模擬存儲
        XCTAssertTrue(favoriteController.isFavorite(trackId: Int(trackId)), "Expected track to be favorite")

    }
    
    func testFetchFavoriteData() {
            // 添加測試數據到模擬的 Core Data 存儲
            let context = mockPersistentContainer.viewContext
            let musicFavorite = MusicFavorite(context: context)
            musicFavorite.trackId = 123
            musicFavorite.trackName = "Test Track"
            try? context.save()

            // 執行 fetchFavoriteData
            viewController.fetchFavoriteData()

            // 驗證 fetchedResultsController 的結果是否包含測試數據
            let fetchedObjects = viewController.fetchResultController.fetchedObjects
            XCTAssertEqual(fetchedObjects?.count, 1)
            XCTAssertEqual(fetchedObjects?.first?.trackName, "Test Track")
    }
    
    func testisFavorite() {
        
    }
    
    func testremoveFromFavorite() {
        
    }
}
