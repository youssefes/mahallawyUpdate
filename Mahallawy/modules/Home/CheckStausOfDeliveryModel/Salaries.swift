/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Salaries : Codable {
	let taiarid : String?
	let age : String?
	let profile_img : String?
	let moto_img : String?
	let driving_license : String?
	let card_img_img : String?
	let orders_count : String?
	let orders_count_today : String?
	let wallet : String?
	let total_salaries : String?
	let total_orders : String?
	let availability : String?
	let activated_by_admin : String?
	let status : Bool?
	let taiar_ratio : String?
	let mahallawy_ratio : String?

	enum CodingKeys: String, CodingKey {

		case taiarid = "taiarid"
		case age = "age"
		case profile_img = "profile_img"
		case moto_img = "moto_img"
		case driving_license = "driving_license"
		case card_img_img = "card_img_img"
		case orders_count = "orders_count"
		case orders_count_today = "orders_count_today"
		case wallet = "wallet"
		case total_salaries = "total_salaries"
		case total_orders = "total_orders"
		case availability = "availability"
		case activated_by_admin = "activated_by_admin"
		case status = "status"
		case taiar_ratio = "taiar_ratio"
		case mahallawy_ratio = "mahallawy_ratio"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		taiarid = try values.decodeIfPresent(String.self, forKey: .taiarid)
		age = try values.decodeIfPresent(String.self, forKey: .age)
		profile_img = try values.decodeIfPresent(String.self, forKey: .profile_img)
		moto_img = try values.decodeIfPresent(String.self, forKey: .moto_img)
		driving_license = try values.decodeIfPresent(String.self, forKey: .driving_license)
		card_img_img = try values.decodeIfPresent(String.self, forKey: .card_img_img)
		orders_count = try values.decodeIfPresent(String.self, forKey: .orders_count)
		orders_count_today = try values.decodeIfPresent(String.self, forKey: .orders_count_today)
		wallet = try values.decodeIfPresent(String.self, forKey: .wallet)
		total_salaries = try values.decodeIfPresent(String.self, forKey: .total_salaries)
		total_orders = try values.decodeIfPresent(String.self, forKey: .total_orders)
		availability = try values.decodeIfPresent(String.self, forKey: .availability)
		activated_by_admin = try values.decodeIfPresent(String.self, forKey: .activated_by_admin)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		taiar_ratio = try values.decodeIfPresent(String.self, forKey: .taiar_ratio)
		mahallawy_ratio = try values.decodeIfPresent(String.self, forKey: .mahallawy_ratio)
	}

}