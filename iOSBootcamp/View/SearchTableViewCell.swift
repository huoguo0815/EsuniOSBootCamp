//
//  SearchTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/10.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var CoverImageView: UIImageView!
    @IBOutlet var TrackNameLabel: UILabel!
    @IBOutlet var ArtistNameLabel: UILabel!
    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var FavoriteButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
