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

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var musicFavorite: [MusicFavorite] = []
    var fetchResultController: NSFetchedResultsController<MusicFavorite>!
    
    
    //var appsetting: AppSetting!

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        print("FavoriteViewController is ready")
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
    
    //MARK: tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showfavoritecell", for: indexPath) as! FavoriteTableViewCell
        print("cell is ready")
        configure(cell: cell, forRowAt: indexPath)
        return cell
    }
    
    //配置cell
    func configure(cell: FavoriteTableViewCell, forRowAt indexPath: IndexPath) {
        let favoriteResults = musicFavorite[indexPath.row]
        
        //配置文字部分
        cell.TrackNameLabel.text = favoriteResults.trackName
        cell.ArtistNameLabel.text = favoriteResults.artistName
        if favoriteResults.description.isEmpty {
            cell.DescriptionLabel.isHidden = true
        } else {
            cell.DescriptionLabel.isHidden = false
            cell.DescriptionLabel.text = favoriteResults.description
        }
        
        //透過SDWebImage配置照片
        let imageURL = favoriteResults.artworkUrl100
        cell.CoverImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"), options: SDWebImageOptions.scaleDownLargeImages) { (image, error, cacheType, imageURL) in
                if let error = error {
                    // 錯誤處理
                    print(error.localizedDescription)
                }
            }
        
        print("already configure")
        
    }
    

    

}
