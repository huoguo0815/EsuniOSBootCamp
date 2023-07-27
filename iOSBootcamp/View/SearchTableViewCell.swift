//
//  SearchTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/10.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TrackNameLabel: UILabel!
    @IBOutlet weak var ArtistNameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    var delegate: SearchDelegate?
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        delegate?.cellButtonTapped(for: self)
        print("button is tapped")
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

protocol SearchDelegate {
    func cellButtonTapped(for cell: SearchTableViewCell)
}
