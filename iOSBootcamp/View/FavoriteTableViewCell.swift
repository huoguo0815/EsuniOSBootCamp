//
//  FavoriteTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet var favoriteTitle: UILabel!
    @IBOutlet var favoriteCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
