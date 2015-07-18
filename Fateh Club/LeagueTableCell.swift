//
//  LeagueTableCell.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/18/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit

class LeagueTableCell: UITableViewCell {

    @IBOutlet weak var _teamRank: UILabel!
    @IBOutlet weak var _teamLogo: UIImageView!
    @IBOutlet weak var _teamName: UILabel!
    @IBOutlet weak var _teamMatchesTotal: UILabel!
    @IBOutlet weak var _teamMatchesWon: UILabel!
    @IBOutlet weak var _teamMatchesDraw: UILabel!
    @IBOutlet weak var _teamMatchesLost: UILabel!
    @IBOutlet weak var _teamGoalsPro: UILabel!
    @IBOutlet weak var _teamGoalsagainst: UILabel!
    @IBOutlet weak var _teamPoints: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
