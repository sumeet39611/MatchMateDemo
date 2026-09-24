//
//  Profile.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import Foundation
import SwiftData

enum MatchStatus: String, Codable {
    case pending
    case accepted
    case declined

    var title: String {
        switch self {
        case .pending: "Pending"
        case .accepted: "Accepted"
        case .declined: "Declined"
        }
    }
}

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

    var displayName: String {
        "\(name.first) \(name.last)"
    }
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

@Model
final class ProfileEntity {
    @Attribute(.unique) var id: String
    var gender: String
    var title: String
    var firstName: String
    var lastName: String
    var city: String
    var state: String
    var country: String
    var email: String
    var phone: String
    var cell: String
    var nationality: String
    var dob: Date
    var registered: Date
    var largeImageURL: String
    var mediumImageURL: String
    var statusRawValue: String
    var page: Int

    init(profile: Profile, page: Int, status: MatchStatus = .pending) {
        self.id = profile.id
        self.gender = profile.gender
        self.title = profile.name.title
        self.firstName = profile.name.first
        self.lastName = profile.name.last
        self.city = profile.location.city
        self.state = profile.location.state
        self.country = profile.location.country
        self.email = profile.email
        self.phone = profile.phone
        self.cell = profile.cell
        self.nationality = profile.nat
        self.dob = profile.dob.date
        self.registered = profile.registered.date
        self.largeImageURL = profile.picture.large.absoluteString
        self.mediumImageURL = profile.picture.medium.absoluteString
        self.statusRawValue = status.rawValue
        self.page = page
    }

    var status: MatchStatus {
        get { MatchStatus(rawValue: statusRawValue) ?? .pending }
        set { statusRawValue = newValue.rawValue }
    }

    var displayName: String {
        "\(firstName) \(lastName)"
    }

    var imageURL: URL? {
        URL(string: largeImageURL)
    }
}
