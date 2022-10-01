//
//  AttendanceCell.swift
//  attendance
//
//  Created by TechCenter on 23/05/22.
//

import UIKit

class AttendanceCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var viewOutTime: UIView!
    
    @IBOutlet var btnEndTime: UIButton!
    @IBOutlet var btnStartTime: UIButton!
    @IBOutlet var lblOutTime: UILabel!
    @IBOutlet var viewIntime: UIView!
    @IBOutlet var leadingBtn: NSLayoutConstraint!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet weak var btnStartAtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOutTime.layer.cornerRadius = viewOutTime.frame.height / 2
        viewIntime.layer.cornerRadius = viewIntime.frame.height / 2

        btnStartAtn.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
