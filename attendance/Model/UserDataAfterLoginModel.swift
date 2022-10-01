// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try Welcome(json)

import Foundation

// MARK: - Welcome
struct UserDataAfterLogin: Codable {
    let employeeid: Int
    let employeeName, employeeType, employstatus: String
    let attendencedistance: Double
    let employeeIntime, employeeOutime: String
    let departmentid: Int
    let departmentcode, departmentname: String
    let areid: Int
    let areacode, areaname: String
    let arealat, arealong: Double
    let masterEmployeeid, employeecontactno: Int
    let masterdeviceid: String
    let errormessage: Errormessage
}

// MARK: Welcome convenience initializers and mutators

extension UserDataAfterLogin {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserDataAfterLogin.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        employeeid: Int? = nil,
        employeeName: String? = nil,
        employeeType: String? = nil,
        employstatus: String? = nil,
        attendencedistance: Double? = nil,
        employeeIntime: String? = nil,
        employeeOutime: String? = nil,
        departmentid: Int? = nil,
        departmentcode: String? = nil,
        departmentname: String? = nil,
        areid: Int? = nil,
        areacode: String? = nil,
        areaname: String? = nil,
        arealat: Double? = nil,
        arealong: Double? = nil,
        masterEmployeeid: Int? = nil,
        employeecontactno: Int? = nil,
        masterdeviceid: String? = nil,
        errormessage: Errormessage? = nil
    ) -> UserDataAfterLogin {
        return UserDataAfterLogin(
            employeeid: employeeid ?? self.employeeid,
            employeeName: employeeName ?? self.employeeName,
            employeeType: employeeType ?? self.employeeType,
            employstatus: employstatus ?? self.employstatus,
            attendencedistance: attendencedistance ?? self.attendencedistance,
            employeeIntime: employeeIntime ?? self.employeeIntime,
            employeeOutime: employeeOutime ?? self.employeeOutime,
            departmentid: departmentid ?? self.departmentid,
            departmentcode: departmentcode ?? self.departmentcode,
            departmentname: departmentname ?? self.departmentname,
            areid: areid ?? self.areid,
            areacode: areacode ?? self.areacode,
            areaname: areaname ?? self.areaname,
            arealat: arealat ?? self.arealat,
            arealong: arealong ?? self.arealong,
            masterEmployeeid: masterEmployeeid ?? self.masterEmployeeid,
            employeecontactno: employeecontactno ?? self.employeecontactno,
            masterdeviceid: masterdeviceid ?? self.masterdeviceid,
            errormessage: errormessage ?? self.errormessage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Errormessage
struct Errormessage: Codable {
    let status: Int
    let message, errormessageDescription: String

    enum CodingKeys: String, CodingKey {
        case status, message
        case errormessageDescription = "description"
    }
}

// MARK: Errormessage convenience initializers and mutators

extension Errormessage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Errormessage.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: Int? = nil,
        message: String? = nil,
        errormessageDescription: String? = nil
    ) -> Errormessage {
        return Errormessage(
            status: status ?? self.status,
            message: message ?? self.message,
            errormessageDescription: errormessageDescription ?? self.errormessageDescription
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
