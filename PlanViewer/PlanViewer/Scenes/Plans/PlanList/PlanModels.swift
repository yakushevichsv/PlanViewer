//
//  PlanModel.swift
//  PlanViewer
//
//  Created by syakushevich on 25.06.21.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let planModel = try? newJSONDecoder().decode(PlanModel.self, from: jsonData)

import Foundation
import QuartzCore

// MARK: - PlanModel
struct PlanModel: Decodable {
    let name: String
    let identifier: String
    let house: House
}

extension PlanModel: Identifiable {
    var id: String { identifier }
}

// MARK: - House
struct House: Decodable {
    let rooms: [Room]
}

// MARK: - Room
public struct Room: Decodable {
    public let position: [Float]
    public let walls: [Wall]
}

// MARK: - Wall
public struct Wall: Decodable {
    public let start: [Float]
    public let end: [Float]
}
