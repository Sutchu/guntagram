//
//  UserManagerProtocol.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation

protocol UserManagerProtocol {
    func userDidLogout()
    func errorOccured(error: Error?)
}
