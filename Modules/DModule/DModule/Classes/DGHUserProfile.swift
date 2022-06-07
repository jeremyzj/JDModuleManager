//
//  DGHUserProfile.swift
//  DModule
//
//  Created by Mac on 2022/6/4.
//

import Foundation


public struct DGHUserProfile: Codable {
    var bio: String
    var eventsUrl: String
    var avatarUrl: String
    var login: String
    var followers: Int
    var followingUrl: String
    var following: Int
    var createdAt: String
    var publicRepos: Int
    var publicGists: Int
    var url: String
    var reposUrl: String
    var createAtDate: String {
        get {
            guard let date = stringToFormatDate(createdAt) else {
                return ""
            }
            return date
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case eventsUrl = "events_url"
        case avatarUrl = "avatar_url"
        case followingUrl = "following_url"
        case createdAt = "created_at"
        case publicRepos = "public_repos"
        case reposUrl = "repos_url"
        case publicGists = "public_gists"
        case bio, login, followers, url, following
    }
}

func stringToFormatDate(_ string:String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.locale = .current

    guard let date = dateFormatter.date(from: string) else {
        return nil
    }

    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "MMMM, dd, yyyy"
    return newDateFormatter.string(from: date)
}
