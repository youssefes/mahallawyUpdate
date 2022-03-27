//
//  favouirtesModel.swift
//  Mahallawy
//
//  Created by youssef on 4/9/21.
//  Copyright © 2021 youssef. All rights reserved.
//
import Foundation

// MARK: - Favorites
struct Favorites: Codable {
    let followers: [Follower]?

    enum CodingKeys: String, CodingKey {
        case followers = "Followers"
    }
}

// MARK: - Follower
struct Follower: Codable {
    let id, fullname, brandlogo, address: String?
    let brandPics, phone, longitude, followerDescription: String?
    let categoryname: String?
    let nomOfRaters: Int?
    let isFollow, isRate: Bool?
    let  currentrate: Float?
    let latitude, worktime: String?

    enum CodingKeys: String, CodingKey {
        case id, fullname, brandlogo, address
        case brandPics = "brand_pics"
        case phone, longitude
        case followerDescription = "description"
        case categoryname
        case nomOfRaters = "nom_of_raters"
        case isFollow
        case isRate = "is_rate"
        case latitude, worktime
        case currentrate
    }
}
