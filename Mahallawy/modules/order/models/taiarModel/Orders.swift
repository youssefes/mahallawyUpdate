/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Orders : Codable {
	let orderid : String?
	let customer_name : String?
	let customer_phone : String?
	let customer_location : String?
	let customer_longitude : String?
	let customer_latitude : String?
	let shop_name : String?
	let shop_phone : String?
	let user_id : String?
	let delivery_id : String?
	let delivery_name : String?
    let deleviry_phone : String?
	let shop_location : String?
	let shop_longitde : String?
	let shop_latitude : String?
	let deliver_statues : String?
	let delevery_sallary : String?
	let updated_at : String?
	let created_at : String?
	let products : [Product]?

	enum CodingKeys: String, CodingKey {

		case orderid = "orderid"
		case customer_name = "customer_name"
		case customer_phone = "customer_phone"
		case customer_location = "customer_location"
		case customer_longitude = "customer_longitude"
		case customer_latitude = "customer_latitude"
		case shop_name = "shop_name"
		case shop_phone = "shop_phone"
		case user_id = "user_id"
		case delivery_id = "delivery_id"
		case delivery_name = "delivery_name"
        case deleviry_phone = "deleviry_phone"
		case shop_location = "shop_location"
		case shop_longitde = "shop_longitde"
		case shop_latitude = "shop_latitude"
		case deliver_statues = "deliver_statues"
		case delevery_sallary = "delevery_sallary"
		case updated_at = "updated_at"
		case created_at = "created_at"
		case products = "products"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		orderid = try values.decodeIfPresent(String.self, forKey: .orderid)
		customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
		customer_phone = try values.decodeIfPresent(String.self, forKey: .customer_phone)
		customer_location = try values.decodeIfPresent(String.self, forKey: .customer_location)
		customer_longitude = try values.decodeIfPresent(String.self, forKey: .customer_longitude)
		customer_latitude = try values.decodeIfPresent(String.self, forKey: .customer_latitude)
		shop_name = try values.decodeIfPresent(String.self, forKey: .shop_name)
		shop_phone = try values.decodeIfPresent(String.self, forKey: .shop_phone)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		delivery_id = try values.decodeIfPresent(String.self, forKey: .delivery_id)
		delivery_name = try values.decodeIfPresent(String.self, forKey: .delivery_name)
        deleviry_phone = try values.decodeIfPresent(String.self, forKey: .deleviry_phone)
		shop_location = try values.decodeIfPresent(String.self, forKey: .shop_location)
		shop_longitde = try values.decodeIfPresent(String.self, forKey: .shop_longitde)
		shop_latitude = try values.decodeIfPresent(String.self, forKey: .shop_latitude)
		deliver_statues = try values.decodeIfPresent(String.self, forKey: .deliver_statues)
		delevery_sallary = try values.decodeIfPresent(String.self, forKey: .delevery_sallary)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		products = try values.decodeIfPresent([Product].self, forKey: .products)
	}

}
