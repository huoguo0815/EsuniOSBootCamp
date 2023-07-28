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

class FavoriteViewController: UIViewController {
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    lazy var dataSource = configureDataSource()
    
    enum Section {
        case all
    }
    
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
    
    
    //var appsetting: AppSetting!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.dataSource = dataSource
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
        fetchFavoriteData()
        configureDataSource()
    }
    
    //配置cell
    func configureDataSource() -> UITableViewDiffableDataSource<Section, MusicFavorite> {
        
        
        let dataSource = UITableViewDiffableDataSource<Section, MusicFavorite>(tableView: favoriteTableView)
            { tableView, indexPath, music in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "showfavoritecell", for: indexPath) as! FavoriteTableViewCell
                
                let itemResults = music
                
                //配置文字部分
                cell.TrackNameLabel.text = itemResults.trackName
                cell.ArtistNameLabel.text = itemResults.artistName
                if itemResults.description.isEmpty {
                    cell.DescriptionLabel.isHidden = true
                } else {
                    cell.DescriptionLabel.isHidden = false
                    cell.DescriptionLabel.text = itemResults.description
                }
                
                //透過SDWebImage配置照片
                let imageURL = itemResults.artworkUrl100
                cell.CoverImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"), options: SDWebImageOptions.scaleDownLargeImages) { (image, error, cacheType, imageURL) in
                    if let error = error {
                        // 錯誤處理
                        print(error.localizedDescription)
                    }
                }
                
            return cell
                
            }
        
        return dataSource
    }
    
    func updateSnapShot(animatingChange: Bool = false) {
        
        guard let fetchedObjects = fetchResultController.fetchedObjects else {
            return
        }
        
        //創建快照
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicFavorite>()
        snapshot.appendSections([.all])
        snapshot.appendItems(fetchedObjects, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    

    

}

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapShot()
    }
}
