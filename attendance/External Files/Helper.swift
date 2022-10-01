//
//  Helper.swift
//  attendance
//
//  Created by Paramveer Singh on 01/09/22.
//

import Foundation
import UIKit

class Utility : NSObject {

   static func openPopUP(Title: String,Message: String, vc: UIViewController){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style:   UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
   }
    
}
