//
//  File.swift
//  Mahallawy
//
//  Created by jooo on 7/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - GetMyCartModel
struct GetMyCartModel: Codable {
    let carts: [Cart]?
}

// MARK: - Cart
struct Cart: Codable {
    let cartID, userid, advertiseID, orderName , shop_id , shop_name: String?
    let orderPrice: String?
    let orderImg: String?
    let userDescription, count: String?

    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case userid
        case advertiseID = "advertise_id"
        case orderName = "order_name"
        case orderPrice = "order_price"
        case orderImg = "order_img"
        case userDescription = "user_description"
        case count
        case shop_id = "shop_id"
        case shop_name = "shop_name"
    }
}
