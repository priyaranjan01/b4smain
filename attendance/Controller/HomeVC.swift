//
//  HomeVC.swift
//  attendance
//
//  Created by TechCenter on 04/05/22.
//

import UIKit
import CoreLocation
import Network
class HomeVC: UIViewController , SideMenuViewControllerDelegate {
    var gestureEnabled: Bool = true
    var startAttendance = false
    var userDataAfterLogin : UserDataAfterLogin?
    @IBOutlet weak var tblView: UITableView!
    var dataUserDic = NSDictionary.init()
    var attendanceDic = NSDictionary.init()
    var dataDic = [NSDictionary].init()
    var networkCheck = NetworkCheck.sharedInstance()
    var masterId = "fW8YyYBUTO61_AaZAwDLTQ:APA91bEC9iO5VPanmR04wumcbV886HO1PJqYZREQwLYj1p_YFQT4MoRd8NdQmMfAwl_-ZUIPtza_JMRevgp0K5iqc1S5ldDGJ_ewWUjEBRDq76K4JFY8h2nEMdYC24BP0QNDQmnToYcu"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            self.sideMenuState(expanded: false)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            self.sideMenuState(expanded: false)
            alertLogOut()
        default:
            break
        }
    }
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private var sideMenuViewController: SideVC!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    
    @IBOutlet weak var btnMenu: UIButton!
    private var sideMenuShadowView: UIView!
    
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(self.startAttendance, forKey: "startAttendance")
        self.tblView.register(UINib(nibName: "ListTblCell", bundle: nil), forCellReuseIdentifier: "ListTblCell")
        self.btnMenu.setImage(UIImage.init(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(location), name: Notification.Name("CustomeNotificationName"), object: nil)
        topView.addBottomShadow()
        // Shadow Background View
        self.tblView.register(UINib(nibName: "AttendanceCell", bundle: nil), forCellReuseIdentifier: "AttendanceCell")
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideVC") as? SideVC
        self.sideMenuViewController.delegate = self
        
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 4 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        // Side Menu AutoLayout
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
            view.insertSubview(self.sideMenuShadowView, at: 3)
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        callUserAPI()
        getAttendanceApi()
    }
    
    var outBool = false
    func calculateDistance()
    {
        let areaLocation = CLLocation(latitude: arealat, longitude: arealong)
        //My Next Destination
        let currentLocation = CLLocation(latitude: getRealCoordinatesRoundOff(lat), longitude: getRealCoordinatesRoundOff(long))
        //Finding my distance to my next destination (in metres)
        let distance = areaLocation.distance(from: currentLocation)
        if UserDefaults.standard.value(forKey: "startAttendance") as? Bool == true
        {
        if distance > attendencedistance
        {
            if outBool == false
            {
            self.getMovementApi(rangeType: "OUT")
            }
        }
        else
        {
            if outBool == true
            {
            self.getMovementApi(rangeType: "IN")
            }
        }
        }
    }
    
    func getRealCoordinatesRoundOff(_ string : String) -> CLLocationDegrees
    {
        var resultCoordinate = CLLocationDegrees(Double(round(10000 * Double(string)!) / 10000))
       if (String(describing: resultCoordinate).count) < 7
        {
           resultCoordinate = resultCoordinate + 0.0009 - 0.001
       }
        return  Double(string)!
    }
    
    func alertLogOut()
    {
        let alert = UIAlertController(title: "", message: "Are you sure to log out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            UserDefaults.standard.removeObject(forKey: "userData")
            if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "InitialController") as! UINavigationController
                
                delegate.window?.rootViewController = viewController
                delegate.window?.makeKeyAndVisible()
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            print("No")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func location()
    {
        if UIApplication.shared.applicationState == .active {
            calculateDistance()
           
        }
        else{
            calculateDistance()
//            let notification = UILocalNotification()
//            notification.alertTitle = "Title"
//            notification.alertBody = "Latitude" + lat + " " + "Longitude" + long
//            notification.soundName = "Default"
//            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func getMovementApi(rangeType : String){

        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            let urlString = baseUrl + ApiName().movementApi + "?employeeid=" + String(describing: (dict["employeeId"] as AnyObject)) + "&latitude=\(lat)" + "&longitude=\(long)" + "&rangevalues=" + rangeType
            print(urlString)
            guard let url = URL(string: urlString) else{
                return
            }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                if let data = data, let string = String(data: data, encoding: .utf8){
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        if let json = json
                        {
                            print(json)
                           if String(describing: (json["status"] as AnyObject))  == "200"
                            {
                            if self.outBool == false
                            {
                                self.outBool = true
                            }
                            else
                            {
                                self.outBool = false
                            }
                               self.sendPushNotification(to: self.masterId, title: "Alert", body: "Mr. " + (dict["firstName"] as? String ?? "") + " " + (dict["lastName"] as? String ?? "") + " " + rangeType + " Side the Office.Please Contact Us!", user: "", playerFrstId: "", playerSecndId: "", hostName: "", nonHostName: "") { value in
                                 print(value)
                             }
                           }
                        }
                    } catch {
                        print("Something went wrong")
                    }
                }
            }
            task.resume()
        }
    }

    
    func getAttendanceApi(){
        
        if networkCheck.currentStatus == .satisfied{

        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            let urlString = baseUrl + ApiName().getAttendanceApi + String(describing: (dict["employeeId"] as AnyObject))
            DispatchQueue.main.async {
                self.LoadingStart()
            }
            print(urlString)
            guard let url = URL(string: urlString) else{
                DispatchQueue.main.async {
                    self.LoadingStop()
                }
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
                            print(json)
                            if let errorMessage = json["errormessage"] as? NSDictionary
                            {
                                if String(describing: (errorMessage["status"] as AnyObject)) == "200"
                                {
                                    self.attendanceDic = json
                                    if String(describing: (self.attendanceDic["employeeIntime"] as AnyObject)) != ""
                                    {
                                        self.startAttendance = true
                                        UserDefaults.standard.setValue(self.startAttendance, forKey: "startAttendance")
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.LoadingStop()

                                self.tblView.reloadData()
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

    func testApi()
    {
        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            NetworkClass.getDataFromApi(url: baseUrl + ApiName().employeeDataApi + String(describing: (dict["employeeId"] as AnyObject)), isLoaderReq: true) { (result : Result<UserDataAfterLogin,Error>) in
                switch result {
                    case .success(let model):
                    if model.errormessage.status == 200
                    {
                    }
                    case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func callUserAPI(){
        if networkCheck.currentStatus == .satisfied{

        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            let urlString = baseUrl + ApiName().employeeDataApi + String(describing: (dict["employeeId"] as AnyObject))
            print(urlString)
            guard let url = URL(string: urlString) else{
                return
            }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                if let data = data, let string = String(data: data, encoding: .utf8){
                    print(string)
                    do {
                        let decoder = JSONDecoder()
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        self.userDataAfterLogin = try decoder.decode(UserDataAfterLogin.self, from: data)
                        
                        if let json = json
                        {
                            self.dataUserDic = json
                            UserDefaults.standard.set(self.dataUserDic, forKey: "UserInfo")
                            attendencedistance = self.userDataAfterLogin!.attendencedistance
                            self.masterId = String(describing: self.userDataAfterLogin!.masterEmployeeid)
                            //(self.dataUserDic["attendencedistance"] as? Double) ?? 0.0
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    } catch {
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
    
    func callNotificationAPI(){
        if networkCheck.currentStatus == .satisfied{

        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            let urlString = baseUrl + ApiName.api.notificationListApi + String(describing: (dict["employeeId"] as AnyObject))
            
            print(urlString)
            guard let url = URL(string: urlString) else{
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
                                self.tblView.reloadData()
                            }
                        }
                      
                    } catch {
                        
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

    func callAttendanceAPI(){
        
        if  let dict = UserDefaults.standard.value(forKey: "userData") as? NSDictionary
        {
            let urlString = baseUrl + ApiName.api.attendanceApi + "?employeeid=" + String(describing: (dict["employeeId"] as AnyObject)) + "&latitude=" + lat + "&longitude=" + long
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
                        if let dict = json
                        {
                            if String(describing: dict["status"] as AnyObject) == "200"
                            {
                                self.getAttendanceApi()
                            }
                            
                        }
                       
                    } catch {
                       
                        print("Something went wrong")
                    }
                }
            }
            task.resume()
        }
    }

        
    @IBAction func btnLoc(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LocationVC") as! LocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        showViewController(viewController: UINavigationController.self, storyboardId: "HomeVC")
        
    }
    // Keep the state of the side menu (expanded or collapse) in rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                //               self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }
    @IBAction func btnMenuAct(_ sender: UIButton) {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
        
        //self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        callNotificationAPI()
        self.navigationController?.isNavigationBarHidden = true
    }
    func sendPushNotification(to token: String, title: String, body: String,user:String,playerFrstId:String,playerSecndId:String,hostName:String,nonHostName:String,completion:@escaping(Bool)->()) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        print("jhjgmggkgkgkkhkjkjkj",token)
//        let paramString : [String : Any] = ["to" : token,
//                                                   "notification" : ["title" : "title", "body" : "body"],
//                                                   "data" : ["user" : "fd"]
 //               ]
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : user,"playerFrstId":playerFrstId,"playerSecndId":playerSecndId,"hostName":hostName,"clientName":nonHostName,"gcm.notification.page":"TicTacToe","pageType":"TicTacToe"]
        ]

        
        print(paramString)
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAI3uGnRI:APA91bEmckW-Qu8y3PjPOlc8EFImh3KdigMS8gscPkGqQMxgMUxC9BV3p4jZGHolGkWkx4SS9T260xxTXPhJOzCHzJ3VuMmX1JuflPkUoaaaclY9vFmX_YGriw6Z1CnadhF7iZFsMSxe", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict as! NSDictionary))")
                        if (jsonDataDict as? NSDictionary)?.value(forKey: "success") as! Bool == true{
                            completion(true)
                            print("i am called")
                        }else{
                            print("i am not called")
                            completion(false)
                        }
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
                completion(false)
            }
        }
        task.resume()
    }

    
}
extension HomeVC: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    
    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))!  {
            return false
        }
        return true
    }
        
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        // ...
        guard gestureEnabled == true else { return }
        
        
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        
        switch sender.state {
        case .began:
            
            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }
            
            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }
            
            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }
                
                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }
            
        case .changed:
            
            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                        
                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha
                        
                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
    
    // ...
}

extension HomeVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        if section == 2
        {
            return dataDic.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1
        {
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
            viewHeader.backgroundColor = AppColors().appColor
            let label = UILabel(frame: CGRect(x: 20, y: 5, width: self.view.frame.size.width, height: 40))
            label.text = "Employee Details"
            label.font = UIFont.systemFont(ofSize: 17,weight: .semibold)
            label.textColor = .white
            viewHeader.addSubview(label)
            let image = UIImageView(frame: CGRect(x: self.view.frame.size.width - 40, y: 12.5, width: 25, height: 25))
            image.image = UIImage(named: "next")?.withRenderingMode(.alwaysTemplate)
            image.tintColor = .white
            viewHeader.addSubview(image)
            let button = UIButton(frame: CGRect(x: self.view.frame.size.width - 40, y: 12.5, width: 25, height: 25))
            button.addTarget(self, action: #selector(goToAttendance), for: .touchUpInside)
            viewHeader.addSubview(button)
            return viewHeader
        }
        else if section == 2
        {
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
            let viewSpace = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 50))
            viewHeader.backgroundColor = .clear
            viewSpace.backgroundColor = AppColors().appColor
            viewHeader.addSubview(viewSpace)
            let label = UILabel(frame: CGRect(x: 20, y: 15, width: self.view.frame.size.width, height: 40))
            label.text = "Notification"
            label.font = UIFont.systemFont(ofSize: 17,weight: .semibold)
            label.textColor = .white
            viewHeader.addSubview(label)
            return viewHeader
        }
        let view = UIView.init()
        view.backgroundColor = .clear
        return view
    }
    @objc func goToAttendance()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceVC") as! AttendanceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1
        {
            return 50
        }
        else if section == 2
        {
            return 60
        }
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell") as! AttendanceCell
            cell.lblDate.text = Date().today()

            if startAttendance == true
            {
                cell.btnStartTime.isEnabled = false
                cell.lblTime.text = "In Time " + (attendanceDic["employeeIntime"] as? String ?? "")
                cell.lblOutTime.text = "Out Time" + (String(describing: attendanceDic["employeeOutime"] as AnyObject) == "" ? "" : ( "\n" + String(describing: attendanceDic["employeeOutime"] as AnyObject)))
                cell.leadingBtn.constant = 20
                cell.viewIntime.backgroundColor = #colorLiteral(red: 0.9948297143, green: 0.6471836567, blue: 0, alpha: 1)
                cell.viewOutTime.isHidden = false

            }
            else
            {
                cell.lblTime.text = "Not Mark"
                cell.lblOutTime.text = "Out Time"
                cell.viewOutTime.isHidden = true
                cell.viewIntime.backgroundColor = #colorLiteral(red: 0.6849446297, green: 0.03511491418, blue: 0.01537202299, alpha: 1)
                cell.leadingBtn.constant = ((cell.btnStartAtn.frame.width / 2) - 50)
                cell.btnStartTime.isEnabled = true
            }
            cell.btnStartTime.addTarget(self, action: #selector(startEndTime), for: .touchUpInside)
            cell.btnEndTime.addTarget(self, action: #selector(startEndTime), for: .touchUpInside)
            cell.btnStartTime.setTitle("", for: .normal)
            cell.btnEndTime.setTitle("", for: .normal)

            cell.selectionStyle = .none
            cell.backgroundColor = .clear

            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTblCell") as! ListTblCell
            cell.selectionStyle = .none
            cell.lblSecondary.text = dataDic[indexPath.row]["actionType"] as? String
            cell.lblSecondary.isHidden = true
            cell.lblEmpName.text = dataDic[indexPath.row]["message"] as? String
            if (dataDic[indexPath.row]["actionType"] as? String) == "OUT"
            {
                cell.viewBackGround.backgroundColor = .red
            }
            else
            {
                cell.viewBackGround.backgroundColor = #colorLiteral(red: 0.183380127, green: 0.5925325155, blue: 0.4138582051, alpha: 1)
            }
            cell.heightSecondaryLabel.constant = 0
            cell.btnForward.isHidden = false
            cell.btnForward.setTitle("", for: .normal)
            cell.imgForward.isHidden = false
            cell.btnForward.tag = indexPath.row
            cell.btnForward.addTarget(self, action: #selector(btnForward), for: .touchUpInside)
            cell.lblEmpName.frame.size = CGSize(width: cell.lblEmpName.frame.width, height: cell.lblEmpName.intrinsicContentSize.height)
            cell.backgroundColor = .clear
            return cell
        }
        
        let cellView = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5))
        
        return cellView
    }
    @objc func btnForward(_ sender : UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(identifier: "LocationVC") as! LocationVC
        vc.longitude = String(describing: (dataDic[sender.tag]["logitude"] as AnyObject))
        vc.latitude = String(describing:(dataDic[sender.tag]["latitude"] as AnyObject))
        vc.currentLocationStr = "Location"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func startEndTime()
    {
        if startAttendance == false
        {
            startAttendance = true
            UserDefaults.standard.setValue(self.startAttendance, forKey: "startAttendance")

        }
        callAttendanceAPI()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            if startAttendance == false
            {
                startAttendance = true
                UserDefaults.standard.setValue(self.startAttendance, forKey: "startAttendance")

            }
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = .clear
        return view

    }
    
}
