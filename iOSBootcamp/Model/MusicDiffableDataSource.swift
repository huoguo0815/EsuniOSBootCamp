//
//  MusicDiffableDataSource.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/27.
//

import UIKit

enum Section: Int, CaseIterable {
    case movie
    case music
}

class MusicDiffableDataSource: UITableViewDiffableDataSource<Section, SearchItem> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
}
