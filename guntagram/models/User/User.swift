//
//  User.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation

struct User {
    let userName: String
    let mail: String
    var posts: [Post] = []
}
