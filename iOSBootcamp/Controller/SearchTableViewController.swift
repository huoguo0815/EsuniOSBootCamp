//
//  SearchTableViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/10.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var searchResultsCountLabel: UILabel!
    @IBOutlet weak var mediaTypeSegmentedControl: UISegmentedControl!
    
    enum MediaType:String,CaseIterable{
        case movie,music
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //加上搜尋欄位
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search music...", comment: "Search music...")
        searchController.searchBar.backgroundImage = UIImage()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    
    func configure(cell:SearchTableViewCell, forRowAt indexPath: IndexPath) {
        //let itemResults =
        
    }


}
