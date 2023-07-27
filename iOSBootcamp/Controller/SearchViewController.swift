//
//  SearchViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/12.
//

import UIKit
import AFNetworking
import JSONModel
import SafariServices
import CoreData
import SDWebImage

private let reusableIdentifier = "dataCell"

public var mode = "light"

class SearchViewController: UIViewController {
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var searchResultsCountLabel: UILabel!
    @IBOutlet weak var mediaTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchItemBar: UISearchBar!
    
    var delegate: SearchDelegate?
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    lazy var dataSource = configureDataSource()
    
    @IBAction func selectMediaType(_ sendeer: UISegmentedControl) {
        search()
    }
    
    var items = [SearchItem]()
    var musicFavorite: [MusicFavorite] = []
    
    
    enum MediaType: String,CaseIterable {
        case music
        case movie
    }
    
    //MARK: View生命週期

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //itemListTableView.delegate = self
        itemListTableView.dataSource = dataSource
        fetchFavoriteData()
        
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
        
        
    }
    
    //點選進入網頁
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackViewUrl = items[indexPath.row].trackViewUrl
        let controller = SFSafariViewController(url: trackViewUrl)
        present(controller, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: 建立連線
    
    //搜尋連線建立
    func search() {
        searchResultsCountLabel.text = "搜尋中..."
        items = []
        guard let searchTerm = searchItemBar.text else {return}
        let mediaType = MediaType.allCases[mediaTypeSegmentedControl.selectedSegmentIndex].rawValue
        let parameters = [
            "term": searchTerm,
            "media": mediaType
        ]
        SearchController.shared.fetchItems(matching: parameters) { result in
            
            //print(result)
            switch result {
            case .success(let searchResponse):
                DispatchQueue.main.async {
                    self.items = searchResponse
                    self.searchResultsCountLabel.text = "搜尋到\(self.items.count)個結果"
                    //print("try to reload data")
                    self.itemListTableView.reloadData()
                    self.configureDataSource()
                    self.updateSnapShot()
                }
            case .failure(let error):
                self.displayError(error, title: "資料抓取失敗")
                
            }
            
        }
        
    }
    
    //配置cell
    func configureDataSource() -> UITableViewDiffableDataSource<Section, SearchItem> {
        
        print("try to set cell")
        let dataSource = MusicDiffableDataSource(
            
            tableView: itemListTableView,
            cellProvider: { tableView, indexPath, music in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! SearchTableViewCell
                
                let itemResults = self.items[indexPath.row]
                
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
                cell.delegate = self
            return cell
            })
        
        return dataSource
    }
    
    
    
    //錯誤處理
    func displayError(_ error:Error,title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { _ in
                self.search()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Core data讀取資料
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
    
    func updateSnapShot(animatingChange: Bool = false){
        
        if let fetchedObjects = fetchResultController.fetchedObjects {
            musicFavorite = fetchedObjects
        }
        
        //創建快照
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchItem>()
        snapshot.appendSections([.all])
        snapshot.appendItems(items, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    //Thread 1: "Attempted to apply updates to a table view from a UITableViewDiffableDataSource, but the table view's dataSource is not the UITableViewDiffableDataSource. Table view: <UITableView: 0x157079600; frame = (-5 225; 394 622); clipsToBounds = YES; autoresize = W+H; gestureRecognizers = <NSArray: 0x600002bd5da0>; backgroundColor = <UIDynamicSystemColor: 0x600003022780; name = tableBackgroundColor>; layer = <CALayer: 0x60000253e1c0>; contentOffset: {0, 0}; contentSize: {394, 0}; adjustedContentInset: {0, 0, 78, 0}; dataSource: (null)>"
    
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapShot()
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        searchItemBar.resignFirstResponder()
    }
    
}

extension SearchViewController: SearchDelegate {
    func cellButtonTapped(for cell: SearchTableViewCell) {
        guard let indexPath = itemListTableView.indexPath(for: cell) else { return }
        
        let itemResults = items[indexPath.row]
        
        let trackId = itemResults.trackId
        let trackName = itemResults.trackName
        let artistName = itemResults.artistName
        let description = itemResults.description
        let artworkUrl100 = itemResults.artworkUrl100
        
        
        if FavoriteController.shared.isFavorite(trackId: trackId) {
            FavoriteController.shared.removeFromFavorite()
        } else {
            FavoriteController.shared.addToFavorite(trackId: trackId, trackName: trackName, artistName: artistName, artworkUrl100: artworkUrl100)
        }
    }
}
