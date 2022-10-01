//
//  ProfileVC.swift
//  attendance
//
//  Created by Paramveer Singh on 14/06/22.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var lblEmpType: UILabel!
    @IBOutlet var lblAaDhaarNum: UILabel!
    @IBOutlet var lblProfileName: UILabel!
    @IBOutlet var viewTop: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet var viewBackGround: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGround.layer.cornerRadius = 8
        viewTop.addBottomShadow()
        if let dict = UserDefaults.standard.value(forKey: "UserInfo") as? NSDictionary
          {
            lblProfileName.text = "Name: " + (dict["employeeName"] as? String ?? "")
            lblEmpType.text = "Employee Type: " + (dict["employeeType"] as? String ?? "")
            lblAaDhaarNum.text = UserDefaults.standard.value(forKey: "aadharNumber") as? String ?? ""
            //String(describing: (dict["employeeid"] as AnyObject))
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
