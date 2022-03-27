//
//  loginModel.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let info: [Info]
}

// MARK: - Info
struct Info: Codable {
    let status: Bool
    let message : String?
    let id, usertype, fullname, infoDescription: String?
    let email, phone, gender, address: String?
    let brandlogo, longitude, latitude, worktime: String?
    let categoryid, categoryname, pics: String?
    let profile_img, moto_img, card_img_img,driving_license , age : String?
    enum CodingKeys: String, CodingKey {
        case status, id, usertype, fullname, message
        case infoDescription = "description"
        case email, phone, gender, address, brandlogo, longitude, latitude, worktime, categoryid, categoryname, pics
        case profile_img, moto_img, card_img_img,driving_license , age
       
    }
}
