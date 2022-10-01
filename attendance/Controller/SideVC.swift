//
//  SideVC.swift
//  attendance
//
//  Created by TechCenter on 23/05/22.
//

import UIKit
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}
class SideVC: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var delegate: SideMenuViewControllerDelegate?

    var menu: [SideMenuModel] = [
          SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
          SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Profile"),
        SideMenuModel(icon: UIImage(named: "sign_out")!, title: "Log Out")
      ]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = UserDefaults.standard.value(forKey: "UserInfo") as? NSDictionary
          {
            self.lblName.text = (dict["employeeName"] as? String ?? "") 
        }
        self.tblView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.lblVersion.text = ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")
        // Do any additional setup after loading the view.
    }

}

extension SideVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.imgOption.image = menu[indexPath.row].icon
        cell.lblMain.text = menu[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath.row)
    }
}
