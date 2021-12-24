//
//  UserDataSourceProtocol.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation

protocol UserDataSourceProtocol {
    
    func registerFailed(error: Error)
    func userIsRegistered()
    func loginFailed(error: Error)
    func userLoggedIn()
}
