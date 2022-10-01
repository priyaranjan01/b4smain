//
//  SideMenuCell.swift
//  attendance
//
//  Created by TechCenter on 23/05/22.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var imgOption: UIImageView!
    
    @IBOutlet weak var lblMain: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgOption.tintColor = .black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
