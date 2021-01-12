//
//  GlobalIdentifier.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 10/01/21.
//

import Foundation

enum TableViewCellIdentifier: String {
    case homeTableCell = "homeTableCell"
    case SearchTableCell = "SearchTableCell"
    case movieDetailTableCell = "movieDetailTableCell"
    case moviePlayerCell = "moviePlayerCell"
}

enum TableViewHeaderViewNibName: String {
    case HomeTableViewHeaderView = "HomeTableViewHeaderView"
}

enum TableViewHeaderIdentifier: String{
    case HomeTableViewHeader = "HomeTableViewHeader"    
    
}

enum CollectionViewCellIdentifier: String{
    case movieDetailCollectionCell = "movieDetailCollectionCell"
}

enum VCIdentifier: String {
    case MovieDetailVC = "MovieDetailVC"
}
enum DefaultKeys: String {
    case cacheData = "cacheData"
}

enum CollectionViewTag: Int {
    case cast = 1000
    case crew = 1001
    case similarMovie = 1002
}
