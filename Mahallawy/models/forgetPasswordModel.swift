//
//  forgetPasswordModel.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - ForgetPasswordModel
struct ForgetPasswordModel: Codable {
    let response: [Response]
    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
}

// MARK: - Response
struct Response: Codable {
    let statues: Bool
    let message: String
    let order_statues : String?
    
}
struct AddToCartModel: Codable {
    let response: [ResponseCart]
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct ResponseCart: Codable {
    let status: Bool
    let message: String
    
}


// MARK: - ForgetPasswordModel
struct ForgetPasswordMainModel: Codable {
    let Response : [Response]
}




// MARK: - RatingModel
struct RatingModel: Codable {
    let response: [ResponseRating]

    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
}

// MARK: - Response
struct ResponseRating: Codable {
    let statues: Bool
    let message, totalRate: String

    enum CodingKeys: String, CodingKey {
        case statues, message
        case totalRate = "total_rate"
    }
}


// MARK: - ForgetPasswordModel
struct DelivaeryStatusModel: Codable {
    let updateStatues : [DelivaeryStatus]
}


// MARK: - Response
struct DelivaeryStatus: Codable {
    let statues: Bool
    let message, delivery_statues: String

    enum CodingKeys: String, CodingKey {
        case statues, message
        case delivery_statues = "delivery_statues"
    }
}
