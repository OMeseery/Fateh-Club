//
//  MatchTableCell.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/18/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit

class MatchTableCell: UITableViewCell {

    @IBOutlet weak var _MatchDate: UILabel!
    @IBOutlet weak var _MatchTime: UILabel!
    @IBOutlet weak var _MatchResult: UILabel!
    @IBOutlet weak var _MatchTeamALogo: UIImageView!
    @IBOutlet weak var _MatchTeamBLogo: UIImageView!
    @IBOutlet weak var _MatchTeamAName: UILabel!
    @IBOutlet weak var _MatchTeamBName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
