//
//  PersonalViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/19.
//

import UIKit
import CoreData
import SafariServices

class PersonalViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //var appsetting: AppSetting!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iTunesButton: UIButton! {
        didSet {
            iTunesButton.isHighlighted = false
        }
    }
    
    
    
    var musicFavorite: [MusicFavorite] = []
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 導覽列使用大標題
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "System Red")
        
        tableView.dataSource = self
        tableView.delegate = self
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
        
        fetchFavoriteData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMode":
            let destinationController = segue.destination as! ModeViewController
        case "showFavorite":
            let destinationController = segue.destination as! FavoriteViewController
        case "showWeb":
            let destinationController = segue.destination as! WebViewController
        default: break
        }
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
                musicFavorite = fetchResultController.fetchedObjects ?? []
            } catch {
                print("讀取資料出現錯誤\(error)")
            }
        }
        tableView.reloadData()
    }
    

    

}

extension PersonalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath) as! ModeTableViewCell
            
            cell.modeTitle.text = "主題顏色"
            if mode == "light" {
                cell.modeChoose.text = "目前為淺色模式"
            } else {
                cell.modeChoose.text = "目前為深色模式"
            }
            
            
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            // 格式化收藏數字並設定到 Label 上
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let countString = formatter.string(from: NSNumber(value: musicFavorite.count+1000))
            cell.favoriteTitle.text = "收藏項目"
            cell.favoriteCount.text = "目前收藏 \(countString!) 項"
            
            
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for personal controller")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消反灰
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
