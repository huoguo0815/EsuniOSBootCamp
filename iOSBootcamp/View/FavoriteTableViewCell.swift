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
    @IBOutlet weak var CollectionNameLabel: UILabel!
    @IBOutlet weak var MusicTimeLabel: UILabel!
    
    var delegate: FavoriteDelegate?
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        delegate?.FavoritecellButtonTapped(for: self)
        //print("button is tapped")
        
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

protocol FavoriteDelegate {
    func FavoritecellButtonTapped(for cell: FavoriteTableViewCell)
}
