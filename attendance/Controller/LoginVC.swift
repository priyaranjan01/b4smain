//
//  LoginVC.swift
//  attendance
//
//  Created by TechCenter on 03/05/22.
//

import UIKit
import Network

class LoginVC: UIViewController ,NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        //
    }
    
var networkCheck = NetworkCheck.sharedInstance()

    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfMobile: UITextField!
    var dataDic = NSDictionary.init()
    @IBOutlet var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTextField.layer.cornerRadius = 8
        btnLogin.layer.cornerRadius = 8
        tfMobile.delegate = self
        lblVersion.text = "Version " + ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")
        // Side Menu
    }
     

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func callAPI(){
        if networkCheck.currentStatus == .satisfied{

        self.LoadingStart()
        let urlString = baseUrl + ApiName().loginApi + self.tfMobile.text! + "/" + firebaseToken + "/" + "iOS"  + "/" + (UIDevice.current.identifierForVendor?.uuidString ?? "")

        print(urlString)
        guard let url = URL(string: urlString) else{
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
                    self.dataDic = json
                        if let errorMessageDict = self.dataDic["errormessage"] as? NSDictionary
                        {
                           if (errorMessageDict["status"] as! Int) == 200
                            {
                               self.dataDic.setValue("", forKey: "mdeviceuniqueid")
                               UserDefaults.standard.set(self.dataDic, forKey: "userData")
                               UserDefaults.standard.set(self.tfMobile.text!, forKey: "aadharNumber")
                               DispatchQueue.main.async {
                                   self.LoadingStop()
                                   if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                       let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                       let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
                                           delegate.window?.rootViewController = viewController
                                           delegate.window?.makeKeyAndVisible()
                                   }
                               }
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
        else
        {
            Utility.openPopUP(Title: "Network Error!", Message: "Please check your internet connection and try again", vc: self)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnLoginAct(_ sender: Any) {
        if (tfMobile.text!.isEmpty)
        {
            self.showToast(message: "Please add Aadhaar Card Number", font: UIFont.systemFont(ofSize: 17))
            return
        }
        else if (tfMobile.text!.count) < 12
        {
            self.showToast(message: "Aadhaar Card Number should be of 12 characters", font: UIFont.systemFont(ofSize: 17))
            return
        }
        else if (tfMobile.text!) == "111111111111"
        {
            self.showToast(message: "Invalid login credentials", font: UIFont.systemFont(ofSize: 17))
            return
        }
        callAPI()
    }
    
}

extension LoginVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewTextField.layer.borderWidth = 1
        self.viewTextField.layer.borderColor = AppColors().appColor.cgColor
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
           let currentString: NSString = (textField.text ?? "") as NSString
           let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
           return newString.length <= maxLength
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewTextField.layer.borderWidth = 0
        self.viewTextField.layer.borderColor = UIColor.clear.cgColor

    }
    
}


