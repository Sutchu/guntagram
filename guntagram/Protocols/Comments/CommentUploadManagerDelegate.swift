//
//  PostUploadManagerDelegate.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation

protocol CommentUploadManagerDelegate {
    func commentUploaded()
    func uploadFailed(error: Error)
}
