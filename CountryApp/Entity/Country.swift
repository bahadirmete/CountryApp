//
//  Country.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

struct Country: Decodable {
    let name: String
    let region: String
    let code: String
    let capital: String
}

extension Country {
    var searchableText: String {
        (name + " " + capital).lowercased()
    }
}
