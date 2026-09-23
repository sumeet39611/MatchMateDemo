//
//  ProfileListView.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ProfileListView: View {
    var body: some View {
        NavigationStack {
            Group {
                List {
                    ForEach(dummyProfile, id: \.id) { profile in
                        
                        ProfileCard(
                            profile: profile,
                            onAccept: {
                                print("Accepted")
                            },
                            onDecline: {
                                print("Declined")
                            }
                        )
                        .contentShape(Rectangle())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }                    }
                .listStyle(.plain)
                .navigationTitle("Profile Matches")
            }
        }
    }
}

let dummyProfile = [Profile(
    gender: "male",
    name: APIName(
        title: "Mr",
        first: "Sumeet",
        last: ""
    ),
    location: APILocation(
        city: "Mumbai",
        state: "Maharashtra",
        country: "India"
    ),
    email: "sumeet.jagtap@example.com",
    login: APILogin(
        uuid: "dummy-001"
    ),
    dob: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 631152000)
    ),
    registered: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 1577836800)
    ),
    phone: "+91 0011223344",
    cell: "+91 1122334455",
    picture: APIPicture(
        large: URL(string: "https://randomuser.me/api/portraits/men/81.jpg")!,
        medium: URL(string: "https://randomuser.me/api/portraits/med/men/81.jpg")!
    ),
    nat: "IN"
), Profile(
    gender: "male",
    name: APIName(
        title: "Mr",
        first: "Akshay",
        last: ""
    ),
    location: APILocation(
        city: "Pune",
        state: "Maharashtra",
        country: "India"
    ),
    email: "sumeet.jagtap@example.com",
    login: APILogin(
        uuid: "dummy-002"
    ),
    dob: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 631152000)
    ),
    registered: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 1577836800)
    ),
    phone: "+91 0011223344",
    cell: "+91 1122334455",
    picture: APIPicture(
        large: URL(string: "https://randomuser.me/api/portraits/men/81.jpg")!,
        medium: URL(string: "https://randomuser.me/api/portraits/med/men/81.jpg")!
    ),
    nat: "IN"
), Profile(
    gender: "male",
    name: APIName(
        title: "Mr",
        first: "Manav",
        last: ""
    ),
    location: APILocation(
        city: "Thane",
        state: "Maharashtra",
        country: "India"
    ),
    email: "sumeet.jagtap@example.com",
    login: APILogin(
        uuid: "dummy-003"
    ),
    dob: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 631152000)
    ),
    registered: APIDateOfBirth(
        date: Date(timeIntervalSince1970: 1577836800)
    ),
    phone: "+91 0011223344",
    cell: "+91 1122334455",
    picture: APIPicture(
        large: URL(string: "https://randomuser.me/api/portraits/men/81.jpg")!,
        medium: URL(string: "https://randomuser.me/api/portraits/med/men/81.jpg")!
    ),
    nat: "IN"
)]
