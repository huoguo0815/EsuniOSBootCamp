//
//  PersonalViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/19.
//

import UIKit

class PersonalViewController: UIViewController {
    
    var appsetting: AppSetting!
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 導覽列使用大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .blue
        //自訂導覽列外觀
        if let appearance = navigationController?.navigationBar.standardAppearance {
        
            appearance.configureWithTransparentBackground()
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if mode == "light" {
            overrideUserInterfaceStyle = .light
        } else if mode == "dark" {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMode":
            let destinationController = segue.destination as! ModeViewController
        case "showFavorite":
            let destinationController = segue.destination as! FavoriteViewController
        default: break
        }
    }
    

    

}

extension PersonalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath) as! ModeTableViewCell
            
            cell.modeTitle.text = "主題顏色"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            
            cell.favoriteTitle.text = "收藏項目"
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for personal controller")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
