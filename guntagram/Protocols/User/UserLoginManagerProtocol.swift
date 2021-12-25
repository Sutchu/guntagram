//
//  UserLoginManagerProtocol.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation

protocol UserLoginManagerProtocol {
    
    func loginFailed(error: Error)
    func userLoggedIn()
}
