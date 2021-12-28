//
//  CommentFetchManagerDelegate.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation

protocol CommentFetchManagerDelegate {
    func fetchingFailed(error: Error)
    func fetchCompleted()
}
