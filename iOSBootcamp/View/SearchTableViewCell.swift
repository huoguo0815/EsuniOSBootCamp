//
//  SearchTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/10.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TrackNameLabel: UILabel! {
        didSet {
            TrackNameLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var ArtistNameLabel: UILabel! {
        didSet {
            ArtistNameLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var DescriptionLabel: UILabel! {
        didSet {
            DescriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var CollectionName: UILabel! {
        didSet {
            CollectionName.numberOfLines = 1
        }
    }
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ReadMoreButton: UIButton!
    
    var delegate: SearchDelegate?
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        delegate?.cellButtonTapped(for: self)
        //print("button is tapped")
    }
    
    @IBAction func readmoreButtonTapped(_ sender: UIButton) {
        delegate?.readmoreButtonTapped(for: self)
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

protocol SearchDelegate {
    func cellButtonTapped(for cell: SearchTableViewCell)
    func readmoreButtonTapped(for cell: SearchTableViewCell)
}
