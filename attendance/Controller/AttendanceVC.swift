//
//  AttendanceVC.swift
//  attendance
//
//  Created by Paramveer Singh on 09/08/22.
//

import UIKit
import Network

class AttendanceVC: UIViewController {
    var dataDic = [NSDictionary].init()
    var movementDic = NSDictionary.init()
    var networkCheck = NetworkCheck.sharedInstance()

    @IBOutlet var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "ListTblCell", bundle: nil), forCellReuseIdentifier: "ListTblCell")

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        callAPI()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func callAPI(){
        if networkCheck.currentStatus == .satisfied{

        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            self.LoadingStart()
            let urlString = baseUrl + ApiName.api.employeeListApi + String(describing: (dict["employeeId"] as AnyObject))
            
            print(urlString)
            guard let url = URL(string: urlString) else{
                self.LoadingStop()
                return
            }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                if let data = data, let string = String(data: data, encoding: .utf8){
                    print(string)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [NSDictionary]
                        if let json = json
                        {
                            self.dataDic = json
                            print(self.dataDic)
                            DispatchQueue.main.async {
                                self.LoadingStop()
                                self.tblView.reloadData()
                            }

                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.LoadingStop()
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.LoadingStop()
                        }
                        print("Something went wrong")
                    }
                }
            }
            
            task.resume()
        }
        }
        else
        {
            Utility.openPopUP(Title: "Network Error!", Message: "Please check your internet connection and try again", vc: self)
        }
    }
    
    func callMovementAPI(id : Int){
        
        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            self.LoadingStart()
            let urlString = baseUrl + ApiName.api.getMovementbyid + "?id=\(id)"
            
            print(urlString)
            guard let url = URL(string: urlString) else{
                self.LoadingStop()
                return
            }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                if let data = data, let string = String(data: data, encoding: .utf8){
                    print(string)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        if let json = json
                        {
                        self.movementDic = json
                            if let errorMessageDict = self.movementDic["errormessage"] as? NSDictionary
                            {
                                DispatchQueue.main.async {
                                    self.LoadingStop()
                                }

                               if (errorMessageDict["status"] as! Int) == 200
                                {
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                       let vc = self.storyboard?.instantiateViewController(identifier: "LocationVC") as! LocationVC
                                       vc.longitude = String(describing: (self.movementDic["longitude"] as AnyObject))
                                       vc.latitude = String(describing:(self.movementDic["latitiude"] as AnyObject))
                                       vc.currentLocationStr = "Location"
                                       self.navigationController?.pushViewController(vc, animated: true)

                                   })
                               }
                                else
                                {
                                    DispatchQueue.main.async {
                                        self.LoadingStop()
                                    self.showToast(message: errorMessageDict["description"] as! String, font: UIFont.systemFont(ofSize: 15))
                                    }
                                }
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.LoadingStop()
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.LoadingStop()
                        }
                        print("Something went wrong")
                    }
                }
            }
            
            task.resume()
        }
    }



}

extension AttendanceVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTblCell") as! ListTblCell
        cell.selectionStyle = .none
        cell.lblSecondary.text = "IN TIME : " + ((dataDic[indexPath.row]["employeeintime"] as! String) == "" ? "NOT MARK" : dataDic[indexPath.row]["employeeintime"] as! String)
        cell.lblOutTime.text = "OUT TIME : " + ((dataDic[indexPath.row]["employeeoutime"] as! String) == "" ? "NOT MARK" : dataDic[indexPath.row]["employeeoutime"] as! String)
       
        cell.lblSecondary.textColor = (dataDic[indexPath.row]["employeeintime"] as! String) == "" ? UIColor.red : UIColor.green
        
        cell.lblOutTime.textColor = (dataDic[indexPath.row]["employeeoutime"] as! String) == "" ? UIColor.red : UIColor.green
        cell.lblEmpName.text = dataDic[indexPath.row]["employeeNames"] as? String
        cell.btnForward.isHidden = false
        cell.btnForward.tag = indexPath.row
        cell.btnForward.setTitle("", for: .normal)
        cell.imgForward.isHidden = false
        cell.btnForward.addTarget(self, action: #selector(btnForward), for: .touchUpInside)
        cell.backgroundColor = .clear
        return cell
    }
    
    @objc func btnForward(_ sender : UIButton)
    {
        
        if let id = dataDic[sender.tag]["employeechildid"] as? Int
        {
        callMovementAPI(id: id)
        }
//        let vc = self.storyboard?.instantiateViewController(identifier: "LocationVC") as! LocationVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
