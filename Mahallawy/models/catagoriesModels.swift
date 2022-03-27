//
//  catagoriesModels.swift
//  Mahallawy
//
//  Created by youssef on 3/18/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - CatagoriesModels
struct CatagoriesModels: Codable {
    let categories: [Category]
    let purchasedAds: [PurchasedAd]
    let promoted_ads: [PromotedAd]
    enum CodingKeys: String, CodingKey {
        case categories
        case purchasedAds = "purchased_ads"
        case promoted_ads = "promoted_ads"
    }
}

// MARK: - Category
struct Category: Codable {
    let id, catname, nomofbrands, nomofads: String
    let categoryPhoto: String
    let helpPhone: HelpPhone

    enum CodingKeys: String, CodingKey {
        case id, catname, nomofbrands, nomofads
        case categoryPhoto = "category_photo"
        case helpPhone = "help_phone"
    }
}

enum HelpPhone: String, Codable {
    case the0128959495601064290 = "01289594956 - 01064290"
    case the0128959495601064290486 = "01289594956 - 01064290486"
    case the1064290486 = "+1064290486"
}

// MARK: - PurchasedAd
struct PurchasedAd: Codable {
    let id, title: String
    let url: String
    let bannerurl: String
}

// MARK: - PromotedAd
struct PromotedAd: Codable {
    let id, text, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, text
        case createdAt = "created_at"
    }
}
