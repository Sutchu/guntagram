//
//  PostUploadManagerProtocol.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation

protocol PostUploadManagerProtocol {
    func uploadFailed(error: Error)
    func postUploaded()
}
