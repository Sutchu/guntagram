//
//  CreateUserError.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation

enum UserError: Error {

    // Throw when userName is not unique in registration
    case userNameNotUnique
    
    // Throw in all other cases
    case unexpected
}
