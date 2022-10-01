//
//  Constants.swift
//  attendance
//
//  Created by TechCenter on 03/05/22.
//

import Foundation
import UIKit

class AppColors
{
    let appColor = UIColor.black
        //UIColor(red: 0.929, green: 0.229, blue: 0.232, alpha: 1)
}

let baseUrl = "http://trackingapi.schooleduinfo.com/api/"
class ApiName
{
    static let api = ApiName()
    let loginApi = "Employee/GetEmployeedLogninetails/"
    let employeeDataApi = "Employee/GetEmployeeLogindataAfterLogin/"
    let employeeListApi = "Employee/GetChildEmployeeListbyidafterLogin/"
    let notificationListApi = "Notify/Getnotificationdata?id="
    let attendanceApi = "Employee/Attendencedone"
    let getAttendanceApi = "Employee/GetAttendencedailybyid/"
    let movementApi = "Employee/GetEmpoyeeMovement"
    let getMovementbyid = "Employee/GetMovementbyid"

    // adharcare/deviceidoption/devicetypeoptional
}
