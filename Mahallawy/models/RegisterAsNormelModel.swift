//
//  RegisterAsNormelModel.swift
//  Mahallawy
//
//  Created by youssef on 3/18/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - RegisterAsUserModel
struct RegisterAsUserModel: Codable {
    let info: [Info]
}

//// MARK: - Info
//struct dataInfo: Codable {
//    let status: Bool
//    let id, usertype, fullname, infoDescription: String?
//    let email, phone, gender, address: String?
//    let brandlogo, longitude, latitude, worktime: String?
//    let categoryid, categoryname, pics: String?
//    let currentrate, notification, fcmKey: Int?
//    let message : String?
//
//    enum CodingKeys: String, CodingKey {
//        case status, id, usertype, fullname, message
//        case infoDescription = "description"
//        case email, phone, gender, address, brandlogo, longitude, latitude, worktime, categoryid, categoryname, pics, currentrate, notification
//        case fcmKey = "fcm_key"
//    }
//}

