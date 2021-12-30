//
//  CellPostDelegate.swift
//  guntagram
//
//  Created by Cem Kılınç on 27.12.2021.
//

import Foundation

protocol PostCellDelegate {
    func commentsButtonPressed(cell: PostTableViewCell)
    func profileButtonPressed(cell: PostTableViewCell)
}
