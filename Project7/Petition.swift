//
//  Petition.swift
//  Project7
//
//  Created by Oscar Lui on 28/2/2022.
//

import Foundation

struct Petition: Codable,Equatable {
    var title: String
    var body: String
    var signatureCount: Int
}
