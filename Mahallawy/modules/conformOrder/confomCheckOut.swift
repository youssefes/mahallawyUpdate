//
//  confomCheckOut.swift
//  Elsade
//
//  Created by jooo on 5/15/21.
//
import Foundation

// MARK: - ConfirmCheckout
struct ConfirmCheckoutModel: Codable {
    let errors : String?
    let orderID : Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case errors
    }
}

