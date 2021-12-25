//
//  UserDataSourceProtocol.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation

protocol UserRegisterManagerProtocol {
    
    func registerFailed(error: Error)
    func userIsRegistered()
}
