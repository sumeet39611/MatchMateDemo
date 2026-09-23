//
//  Profile.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import Foundation

struct RandomUserResponse: Decodable {
    let results: [Profile]
}

struct Profile: Decodable, Identifiable, Equatable {
    let gender: String
    let name: APIName
    let location: APILocation
    let email: String
    let login: APILogin
    let dob: APIDateOfBirth
    let registered: APIDateOfBirth
    let phone: String
    let cell: String
    let picture: APIPicture
    let nat: String

    var id: String { login.uuid }
}

struct APIName: Decodable, Equatable {
    let title: String
    let first: String
    let last: String
}

struct APILocation: Decodable, Equatable {
    let city: String
    let state: String
    let country: String
}

struct APILogin: Decodable, Equatable {
    let uuid: String
}

struct APIDateOfBirth: Decodable, Equatable {
    let date: Date
}

struct APIPicture: Decodable, Equatable {
    let large: URL
    let medium: URL
}
