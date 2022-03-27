//
//  SubCatagories.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: -SubCatagoriesModel

struct SubCatagoriesModel: Codable {
    let ads: [AdSubCatagories]?
    let info: [InfoSubCatagories]?
}

// MARK: - Ad
struct AdSubCatagories: Codable , Comparable{
    static func < (lhs: AdSubCatagories, rhs: AdSubCatagories) -> Bool {
        return lhs.likes > rhs.likes
    }
    
    let id, title, adDescription: String?
    let pics: String?
    let islike, isFollow, isRate: Bool?
    let likes: String
    let cost, brandname, adress, worktime: String?
    let brandpics: String?
    let phone, longitude, latitude, brandDescription: String?
    let categoryname, brandid: String?
    let brandlogo: String?
    let isgolden, activated: String?
    let viewers : String
    let currentRate: Float?
    let nomOfRate: Int?
    let myRate : Float?
    let updatedAt, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case adDescription = "description"
        case pics, islike, isFollow
        case isRate = "is_rate"
        case likes, cost, brandname, adress, worktime, brandpics, phone, longitude, latitude
        case brandDescription = "brand_description"
        case categoryname, brandid, brandlogo, viewers, isgolden, activated
        case currentRate = "current_rate"
        case myRate = "my_rate"
        case nomOfRate = "nom_of_rate"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}


// MARK: - Info
struct InfoSubCatagories: Codable {
    let status: Bool?
}

