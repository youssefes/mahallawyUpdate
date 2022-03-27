/* 
 Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation

// MARK: - GetMyCartModel
struct myOrderModel: Codable {
    let orders: [Order]?
    let info: [info]?
}

// MARK: - Info
struct info: Codable {
    let status: Bool?
}

// MARK: - Order
struct Order: Codable {
    let orderID, statues, customerID, customerName: String?
    let customerPhone, longitude, latitude, location: String?
    let shopID, shopName, shopDescription, shopEmail: String?
    let shopPhone, shopAddress: String?
    let shopLogo: String?
    let shopLongitude, shopLatitude, shopWorktime, categoryname: String?
    let shopPics: String?
    let products: [Product]?
    let createdAt: String?
    let deleviry_id ,deleviry_name ,delevery_sallary ,deleviry_phone : String?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case statues
        case customerID = "customer_id"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case longitude, latitude, location
        case shopID = "shop_id"
        case shopName = "shop_name"
        case shopDescription = "shop_description"
        case shopEmail = "shop_email"
        case shopPhone = "shop_phone"
        case shopAddress = "shop_address"
        case shopLogo = "shop_logo"
        case shopLongitude = "shop_longitude"
        case shopLatitude = "shop_latitude"
        case shopWorktime = "shop_worktime"
        case categoryname
        case shopPics = "shop_pics"
        case products
        case createdAt = "created_at"
        case deleviry_id = "deleviry_id"
        case deleviry_name = "deleviry_name"
        case  delevery_sallary = "delevery_sallary"
        case  deleviry_phone = "deleviry_phone"
    }
}

// MARK: - Product
struct Product: Codable {
    let advID, productName: String?
    let productImg: String?
    let count, totalCost, orderDescription: String?

    enum CodingKeys: String, CodingKey {
        case advID = "adv_id"
        case productName = "product_name"
        case productImg = "product_img"
        case count
        case totalCost = "total_cost"
        case orderDescription = "order_description"
    }
}
