//
//  JobsModels.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import Foundation

// MARK: - JobsModel
struct JobsModel: Codable {
    let jobs: [Job]?
    let info: [JobInfo]?
}

// MARK: - Info
struct JobInfo: Codable {
    let status: Bool?
}

// MARK: - Job
struct Job: Codable {
    let id, title, jobDescription: String?
    let phone: String?
    let sallary, userid, username, viewers: String?
    let activated, closed: String?
    let updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case jobDescription = "description"
        case phone, sallary, userid, username, viewers, activated, closed
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}

