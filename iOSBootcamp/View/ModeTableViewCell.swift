//
//  ModeTableViewCell.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit

class ModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var modeTitle: UILabel!
    @IBOutlet weak var modeChoose: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
