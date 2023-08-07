//
//  FavoriteViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit
import CoreData
import SDWebImage
import AFNetworking
import SafariServices

class FavoriteViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var musicFavorite: [MusicFavorite] = []
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    lazy var dataSource = configureDataSource()
    
    @IBOutlet weak var mediaTypeSegmentedControl: UISegmentedControl!
    @IBAction func selectMediaType(_ sender: UISegmentedControl) {
        fetchFavoriteData()
        updateSnapShot()
    }
    
    enum MediaType: String,CaseIterable {
        case music
        case movie
    }
    
    enum Section: Int, CaseIterable {
        case music
        case movie
    }
    
    //var appsetting: AppSetting!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.dataSource = dataSource
        favoriteTableView.delegate = self
        mediaTypeSegmentedControl.selectedSegmentIndex = 0 // 設定預設值，0 表示顯示音樂收藏
        fetchFavoriteData()
        updateSnapShot()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNeedsStatusBarAppearanceUpdate()
        
        if mode == "light" {
            
            navigationController?.navigationBar.overrideUserInterfaceStyle = .light
            tabBarController?.tabBar.overrideUserInterfaceStyle = .light
            overrideUserInterfaceStyle = .light
            setNeedsStatusBarAppearanceUpdate()
            
        } else if mode == "dark" {
            
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
            tabBarController?.tabBar.overrideUserInterfaceStyle = .dark
            setNeedsStatusBarAppearanceUpdate()
            
        }
        updateSnapShot()
    }
    
    //點選進入網頁
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //取消反灰
        tableView.deselectRow(at: indexPath, animated: true)
        
        let trackViewUrl = musicFavorite[indexPath.row].trackViewUrl
        let controller = SFSafariViewController(url: trackViewUrl)
        present(controller, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    //Core Data讀取資料
    func fetchFavoriteData() {
        
        let fetchRequest: NSFetchRequest<MusicFavorite> = MusicFavorite.fetchRequest()
        
        
        // 添加條件以便查詢特定類別的收藏項目
        let mediaType = MediaType.allCases[mediaTypeSegmentedControl.selectedSegmentIndex].rawValue
        //print(mediaType)
        if mediaType == "music" {
            fetchRequest.predicate = NSPredicate(format: "kind CONTAINS[c] %@", "song")
        } else {
            fetchRequest.predicate = NSPredicate(format: "kind CONTAINS[c] %@", "feature-movie")
        }
        //print(fetchRequest.predicate)
        let sortDesriptor = NSSortDescriptor(key: "trackId", ascending: true)
        fetchRequest.sortDescriptors = [sortDesriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                musicFavorite = fetchResultController.fetchedObjects ?? []
                //print(musicFavorite[0].trackName)
            } catch {
                print("讀取資料出現錯誤\(error)")
            }
        }
    }
    
    //配置cell
    func configureDataSource() -> UITableViewDiffableDataSource<Section, MusicFavorite> {
        
        
        let dataSource = UITableViewDiffableDataSource<Section, MusicFavorite>(tableView: favoriteTableView)
            { tableView, indexPath, music in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "showfavoritecell", for: indexPath) as! FavoriteTableViewCell
                
                let itemResults = music
                
                //配置文字部分
                cell.TrackNameLabel.text = itemResults.trackName
                cell.TrackNameLabel.sizeToFit()
                cell.ArtistNameLabel.text = itemResults.artistName
                cell.ArtistNameLabel.sizeToFit()
                cell.CollectionNameLabel.text = itemResults.collectionName
                cell.CollectionNameLabel.sizeToFit()
                cell.MusicTimeLabel.text = itemResults.trackTime
                
                if itemResults.trackdescription!.isEmpty {
                    cell.DescriptionLabel.isHidden = true
                } else {
                    cell.DescriptionLabel.isHidden = false
                    cell.DescriptionLabel.text = itemResults.trackdescription
                    cell.DescriptionLabel.sizeToFit()
                }
                
                //透過SDWebImage配置照片
                let imageURL = itemResults.artworkUrl100
                cell.CoverImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"), options: SDWebImageOptions.scaleDownLargeImages) { (image, error, cacheType, imageURL) in
                    if let error = error {
                        // 錯誤處理
                        print(error.localizedDescription)
                    }
                }
                cell.delegate = self
            return cell
                
            }
        
        return dataSource
    }
    
    func updateSnapShot(animatingChange: Bool = false) {
        
        if let fetchedObjects = fetchResultController.fetchedObjects {
            musicFavorite = fetchedObjects
        }
        
        //創建快照
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicFavorite>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(musicFavorite.filter { $0.kind == "song"}, toSection: .music)
        snapshot.appendItems(musicFavorite.filter { $0.kind == "feature-movie"}, toSection: .movie)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    func formatTime(from seconds: Int64) -> String {
        let mills = seconds / 1000
        let hours = mills / 3600
        let minutes = (mills % 3600) / 60
        let seconds = mills % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    

    

}

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapShot()
    }
}

extension FavoriteViewController: FavoriteDelegate {
    func FavoritecellButtonTapped(for cell: FavoriteTableViewCell) {
        
        guard let indexPath = favoriteTableView.indexPath(for: cell) else {
                    return
        }
        
        let trackId = musicFavorite[indexPath.row].trackId
        FavoriteController.shared.removeFromFavorite(trackId: trackId)
        updateSnapShot()
        
    }
}
