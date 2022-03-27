//
//  UploadImageModel.swift
//  Mahallawy
//
//  Created by youssef on 4/6/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - CatagoriesExploreModel
struct UploadImageModel: Codable {
    let data : [UpladeImageData]?

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Datum
struct UpladeImageData: Codable {
    let message: String?
    let imageurl: String?
}


// MARK: - UploadAddvertismentModel
struct UploadAddvertismentModel: Codable {
    let response : [UpladeAddvertisment]
}


// MARK: - contectUsModel
struct contectUsModel: Codable {
     let Response : [contectUsModelData]
}

// MARK: - Addvertisment
struct UpladeAddvertisment: Codable {
    let message: String
    let status: Bool
}


// MARK: - Addvertisment
struct contectUsModelData: Codable {
    let message: String
    let statues: Bool
}





