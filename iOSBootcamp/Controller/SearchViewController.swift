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

class SearchViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var searchResultsCountLabel: UILabel!
    @IBOutlet weak var searchItemBar: UISearchBar!
    
    
    var delegate: SearchDelegate?
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    lazy var dataSource = configureDataSource()
    var TappedIndexPath: IndexPath?
    
    var items = [SearchItem]()
    var musicitems = [SearchItem]()
    var movieitems = [SearchItem]()
    var musicFavorite: [MusicFavorite] = []
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    

    
    //MARK: View生命週期

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.delegate = self
        itemListTableView.dataSource = dataSource
        fetchFavoriteData()
        
        // 將 loadingIndicator 放在畫面中央並隱藏
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchFavoriteData()
        
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
        
        //取消反灰
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let trackViewUrl = movieitems[indexPath.row].trackViewUrl
            let controller = SFSafariViewController(url: trackViewUrl)
            present(controller, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)
        } else {
            let trackViewUrl = musicitems[indexPath.row].trackViewUrl
            let controller = SFSafariViewController(url: trackViewUrl)
            present(controller, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    // 實作 viewForHeaderInSection 方法來自定義 section 的 header
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = .systemGray6 // 自定義 header 的背景色
            
            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textColor = .black
            
            switch section {
            case 0:
                titleLabel.text = "電影"
            case 1:
                titleLabel.text = "音樂"
            default:
                titleLabel.text = ""
            }
            
            titleLabel.sizeToFit()
            titleLabel.frame.origin = CGPoint(x: 14, y: (40 - titleLabel.frame.height) / 2)
            headerView.addSubview(titleLabel)
            return headerView
        }
    
    // 調整 cell 的位置，避免擋住 header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        fetchFavoriteData()
        let itemResults: SearchItem
        //print("tapped path is \(TappedIndexPath), real path is \(indexPath)")
        if let lastTappedIndexPath = TappedIndexPath, TappedIndexPath == indexPath {
            if lastTappedIndexPath.section == 0 {
                itemResults = movieitems[lastTappedIndexPath.row]
                if itemResults.isFullDescriptionVisible {
                    let descriptionLabelHeight = itemResults.description.height(withConstrainedWidth: tableView.bounds.width - 40, font: UIFont.systemFont(ofSize: 17))
                        return 200 + descriptionLabelHeight
                }
            } else {
                itemResults = musicitems[lastTappedIndexPath.row]
                if itemResults.isFullDescriptionVisible {
                    let descriptionLabelHeight = itemResults.description.height(withConstrainedWidth: tableView.bounds.width - 40, font: UIFont.systemFont(ofSize: 17))
                        return 200 + descriptionLabelHeight
                }
            }
            
        }
        return 178
    }

    
    //MARK: 建立連線
    
    //搜尋連線建立
    func search() {
        searchResultsCountLabel.text = "搜尋中..."
        loadingIndicator.startAnimating()
        guard let searchTerm = searchItemBar.text else { return }
        let musicparameters = [
            "term": searchTerm,
            "media": "music",
            ]
        let movieparameters = [
            "term": searchTerm,
            "media": "movie"
        ]
        
        //用DispatchGroup確保兩個搜尋都完成才去顯現結果
        let dispatchGroup = DispatchGroup()
        
        
        //開始搜尋電影
        dispatchGroup.enter()
        SearchController.shared.fetchItems(matching: movieparameters) { result in
            switch result {
            case .success(let searchResponse):
                self.movieitems = searchResponse
                dispatchGroup.leave()
            case .failure(let error):
                self.displayError(error, title: "資料抓取失敗")
                dispatchGroup.leave()
            }
        }
        
        //開始搜尋音樂
        dispatchGroup.enter()
        SearchController.shared.fetchItems(matching: musicparameters) { result in
            //print(result)
            switch result {
            case .success(let searchResponse):
                DispatchQueue.main.async {
                    self.musicitems = searchResponse
                    dispatchGroup.leave()
                }
            case .failure(let error):
                self.displayError(error, title: "資料抓取失敗")
                dispatchGroup.leave()
            }
            
        }
        
        //搜尋完成後開始顯現資料
        dispatchGroup.notify(queue: .main) {
            //self.itemListTableView.reloadData()
            self.loadingIndicator.stopAnimating()
            self.dataSource = self.configureDataSource()
            self.updateSnapShot()
            self.searchResultsCountLabel.text = "搜尋到\(self.movieitems.count + self.musicitems.count)個結果"
        }
        
    }
    
    //配置cell
    func configureDataSource() -> UITableViewDiffableDataSource<Section, SearchItem> {
        
        
        let dataSource = MusicDiffableDataSource(
            
            tableView: itemListTableView,
            cellProvider: { tableView, indexPath, music in
                let  itemResults: SearchItem
                switch Section(rawValue: indexPath.section) {
                case .movie:
                    itemResults = self.movieitems[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath) as! SearchTableViewCell
                    
                    //配置文字部分
                    cell.TrackNameLabel.text = itemResults.trackName
                    cell.TrackNameLabel.sizeToFit()
                    cell.ArtistNameLabel.text = itemResults.artistName
                    cell.ArtistNameLabel.sizeToFit()
                    if itemResults.collectionName.isEmpty {
                        cell.CollectionName.isHidden = true
                    } else {
                        cell.CollectionName.isHidden = false
                        cell.CollectionName.text = itemResults.collectionName
                        cell.CollectionName.sizeToFit()
                    }
                    let timeResult = self.formatTime(from: itemResults.trackTimeMillis)
                    if timeResult == "00" {
                        cell.TimeLabel.isHidden = true
                    } else {
                        cell.TimeLabel.isHidden = false
                        cell.TimeLabel.text = timeResult
                        cell.TimeLabel.sizeToFit()
                    }
                    
                    if itemResults.description.isEmpty {
                        cell.DescriptionLabel.isHidden = true
                    } else {
                        cell.DescriptionLabel.isHidden = false
                        cell.DescriptionLabel.text = itemResults.description
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
                    
                    if FavoriteController.shared.isFavorite(trackId: itemResults.trackId) {
                        cell.FavoriteButton.setTitle("取消收藏", for: .normal)
                    } else {
                        cell.FavoriteButton.setTitle("收藏", for: .normal)
                    }
                    cell.delegate = self
                    return cell
                case .music:
                    itemResults = self.musicitems[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "musiccell", for: indexPath) as! SearchTableViewCell
                    
                    //配置文字部分
                    cell.TrackNameLabel.text = itemResults.trackName
                    cell.TrackNameLabel.sizeToFit()
                    cell.ArtistNameLabel.text = itemResults.artistName
                    cell.ArtistNameLabel.sizeToFit()
                    if itemResults.collectionName.isEmpty {
                        cell.CollectionName.isHidden = true
                    } else {
                        cell.CollectionName.text = itemResults.collectionName
                        cell.CollectionName.sizeToFit()
                    }
                    let timeResult = self.formatTime(from: itemResults.trackTimeMillis)
                    //print("this is music time"+timeResult)
                    cell.TimeLabel.text = timeResult
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
                    
                    if FavoriteController.shared.isFavorite(trackId: itemResults.trackId) {
                        cell.FavoriteButton.titleLabel?.text = "取消收藏"
                    } else {
                        cell.FavoriteButton.titleLabel?.text = "收藏"
                    }
                    cell.delegate = self
                    return cell
                case .none:
                    fatalError("Invalid section")
                }
                    
            }
        )
        
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
            //取得Core Data上下文
            let context = appDelegate.persistentContainer.viewContext
            //建立controller，當資料有變化時取得通知
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                //從Core Data中檢索資料
                try fetchResultController.performFetch()
            } catch {
                print("讀取資料出現錯誤\(error)")
            }
        }
    }
    
    func updateSnapShot(animatingChange: Bool = false) {
        
        //檢索Core Data資料
        if let fetchedObjects = fetchResultController.fetchedObjects {
            musicFavorite = fetchedObjects
        }
        
        //創建快照
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(musicitems, toSection: .music)
        snapshot.appendItems(movieitems, toSection: .movie)
        
        //應用快照
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    func formatTime(from seconds: Int64) -> String {
        let mills = seconds / 1000
        let hours = mills / 3600
        let minutes = (mills % 3600) / 60
        let seconds = mills % 60

        if hours > 0 {
            return String(format:"%d:%02d:%02d" ,hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format:"%d:%02d", minutes, seconds)
        } else {
            return String(format:"%02d", seconds)
        }
    }
    
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapShot()
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        //讓鍵盤關閉
        searchItemBar.resignFirstResponder()
    }
    
}

extension SearchViewController: SearchDelegate {
    func cellButtonTapped(for cell: SearchTableViewCell) {
        guard let indexPath = itemListTableView.indexPath(for: cell) else { return }
        
        if indexPath.section == 0 {
            let itemResults = movieitems[indexPath.row]
            
            let trackId = itemResults.trackId
            let trackName = itemResults.trackName
            let artistName = itemResults.artistName
            let description = itemResults.description
            let artworkUrl100 = itemResults.artworkUrl100
            let kind = itemResults.kind
            let trackViewUrl = itemResults.trackViewUrl
            let collectionName = itemResults.collectionName
            let trackTime = self.formatTime(from: itemResults.trackTimeMillis)
            
            
            if FavoriteController.shared.isFavorite(trackId: trackId) {
                FavoriteController.shared.removeFromFavorite(trackId: trackId)
            } else {
                FavoriteController.shared.addToFavorite(trackId: trackId, trackName: trackName, artistName: artistName, trackdescription: description, artworkUrl100: artworkUrl100, kind: kind, trackViewUrl: trackViewUrl, collectionName: collectionName, trackTime: trackTime)
            }
            cell.FavoriteButton.setTitle(FavoriteController.shared.isFavorite(trackId: itemResults.trackId) ? "取消收藏" : "收藏", for: .normal)
            updateSnapShot()
        } else {
            let itemResults = musicitems[indexPath.row]
            
            let trackId = itemResults.trackId
            let trackName = itemResults.trackName
            let artistName = itemResults.artistName
            let description = itemResults.description
            let artworkUrl100 = itemResults.artworkUrl100
            let kind = itemResults.kind
            let trackViewUrl = itemResults.trackViewUrl
            let collectionName = itemResults.collectionName
            let trackTime = self.formatTime(from: itemResults.trackTimeMillis)
            
            
            if FavoriteController.shared.isFavorite(trackId: trackId) {
                FavoriteController.shared.removeFromFavorite(trackId: trackId)
            } else {
                FavoriteController.shared.addToFavorite(trackId: trackId, trackName: trackName, artistName: artistName, trackdescription: description, artworkUrl100: artworkUrl100, kind: kind, trackViewUrl: trackViewUrl, collectionName: collectionName, trackTime: trackTime)
            }
            cell.FavoriteButton.setTitle(FavoriteController.shared.isFavorite(trackId: itemResults.trackId) ? "取消收藏" : "收藏", for: .normal)
            updateSnapShot()
        }
    }
    
    func readmoreButtonTapped(for cell: SearchTableViewCell) {
        if let indexPath = itemListTableView.indexPath(for: cell) {
            var itemResults: SearchItem
            if indexPath.section == 0 {
                itemResults = movieitems[indexPath.row]
                itemResults.isFullDescriptionVisible.toggle()
                movieitems[indexPath.row].isFullDescriptionVisible = itemResults.isFullDescriptionVisible
            } else {
                itemResults = musicitems[indexPath.row]
                itemResults.isFullDescriptionVisible.toggle()
            }
            
            
            TappedIndexPath = indexPath
            updateSnapShot(animatingChange: true)
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
