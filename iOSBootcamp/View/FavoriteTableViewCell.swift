//
//  FavoriteTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteTitle: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TrackNameLabel: UILabel!
    @IBOutlet weak var ArtistNameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    var itemResults: SearchItem?
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        let itemResults = itemResults
        let trackId = itemResults?.trackId
        let trackName = itemResults?.trackName
        let artistName = itemResults?.artistName
        let description = itemResults?.description
        let artworkUrl100 = itemResults?.artworkUrl100
        
        
        if FavoriteController.shared.isFavorite(trackId: trackId!) {
            FavoriteController.shared.removeFromFavorite()
        } else {
            FavoriteController.shared.addToFavorite(trackId: trackId!, trackName: trackName!, artistName: artistName!, artworkUrl100: artworkUrl100!)
        }
        
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
