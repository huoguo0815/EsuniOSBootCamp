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

private let reusableIdentifier = "dataCell"

public var mode = "light"

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var searchResultsCountLabel: UILabel!
    @IBOutlet weak var mediaTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchItemBar: UISearchBar!
    
    @IBAction func selectMediaType(_ sendeer: UISegmentedControl) {
        search()
    }
    
    var items = [SearchItem]()
    
    
    
    enum MediaType: String,CaseIterable {
        case music
        case movie
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.delegate = self
        itemListTableView.dataSource = self
        navigationController?.navigationBar.backgroundColor = .red
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! SearchTableViewCell
        //print("cell is ready")
        configure(cell: cell, forRowAt: indexPath)
        return cell
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
                }
            case .failure(let error):
                self.displayError(error, title: "資料抓取失敗")
                
            }
            
        }
        
    }
    
    //配置cell
    func configure(cell: SearchTableViewCell, forRowAt indexPath: IndexPath) {
        //print("try to set cell")
        let itemResults = items[indexPath.row]
        //print(itemResults)
        
        //配置文字部分
        cell.TrackNameLabel.text = itemResults.trackName
        cell.ArtistNameLabel.text = itemResults.artistName
        if itemResults.description.isEmpty {
            cell.DescriptionLabel.isHidden = true
        } else {
            cell.DescriptionLabel.isHidden = false
            cell.DescriptionLabel.text = itemResults.description
        }
        
        //配置照片
        SearchController.shared.fetchImage(from: itemResults.artworkUrl100) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.itemListTableView.indexPath(for: cell) {
                        cell.CoverImageView.image = image
                    }
                }
            case .failure(let error):
                self.displayError(error, title: "\(itemResults.trackName)圖片抓取失敗")
                DispatchQueue.main.async {
                    cell.CoverImageView.image = UIImage(systemName: "photo")
                }
            }
            
        }
        
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
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        searchItemBar.resignFirstResponder()
    }
    
}
