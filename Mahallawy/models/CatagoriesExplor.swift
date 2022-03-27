//
//  CatagoriesExplor.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - CatagoriesExploreModel
struct CategoriesExplore: Codable {
    let categories: [CategoriesE]

    enum CodingKeys: String, CodingKey {
        case categories = "Categories"
    }
}

// MARK: - Category
struct CategoriesE: Codable {
    let catID, catName: String?
    let catPhoto: String?
    let brands: [Brand]?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case catID = "cat_id"
        case catName = "cat_name"
        case catPhoto = "cat_photo"
        case brands, count
    }
}

// MARK: - Brand
struct Brand: Codable {
    let id, fullname, brandDescription, email: String?
    let phone, address: String?
    let brandlogo: String?
    let longitude, latitude, worktime, categoryname: String?
    let pics: String?
    let nomOfRaters: Int?
    let myRate : Float?
    let isFollow, isRate: Bool?
    let currentrate: Float?

    enum CodingKeys: String, CodingKey {
        case id, fullname
        case brandDescription = "description"
        case email, phone, address, brandlogo, longitude, latitude, worktime, categoryname, pics
        case nomOfRaters = "nom_of_raters"
        case isFollow
        case isRate = "is_rate"
        case myRate = "my_rate"
        case currentrate
    }
}
