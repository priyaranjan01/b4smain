//
//  ListTblCell.swift
//  attendance
//
//  Created by TechCenter on 25/05/22.
//

import UIKit

class ListTblCell: UITableViewCell {
    @IBOutlet weak var lblEmpName: UILabel!
    
    @IBOutlet var lblOutTime: UILabel!
    @IBOutlet var heightSecondaryLabel: NSLayoutConstraint!
    @IBOutlet var btnForward: UIButton!
    @IBOutlet var imgForward: UIImageView!
    @IBOutlet var lblSecondary: UILabel!
    @IBOutlet weak var viewBackGround: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgForward.image = imgForward.image?.withRenderingMode(.alwaysTemplate)
        viewBackGround.dropShadow()
        viewBackGround.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
