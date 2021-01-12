//
//  MoviePlayerTableViewCell.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 12/01/21.
//

import UIKit

class MoviePlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMoviePlayer: UIView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    @IBOutlet weak var lblMovieLanguage: UILabel!
    @IBOutlet weak var lblMovieGenre: UILabel!
    @IBOutlet weak var lblMovieSynopsis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
