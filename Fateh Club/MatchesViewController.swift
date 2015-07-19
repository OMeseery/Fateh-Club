//
//  MatchesViewController.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/18/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit
import Alamofire


class MatchesViewController: UIViewController {

    @IBOutlet weak var matchesTable : UITableView!
    var matchesArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchesTable.dataSource = self;
        self.matchesTable.delegate = self;
        self.matchesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.loadMatchesTableInSeaseon(9340)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MatchesViewController : UITableViewDataSource {
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.matchesArray?.count ?? 0
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MatchTableCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: MatchTableCell, forRowAtIndexPath: NSIndexPath) {
        cell._MatchDate.text = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("date_utc") as! String)
        let time = self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("time_utc") as! String
        cell._MatchTime.text = time.substringToIndex(advance(time.startIndex, 5))
        
        cell._MatchTeamAName.text = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("club_name_A") as! String)
        cell._MatchTeamBName.text = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("club_name_B") as! String)
        
        cell._MatchTeamAResult.text = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("fs_A") as! String)
    
        cell._MatchTeamBResult.text = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("fs_B") as! String )

        let imageURLTeamA = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("club_logo_A") as! String )
        cell._MatchTeamALogo.imageFromUrl(imageURLTeamA)
        
        let imageURLTeamB = (self.matchesArray?.objectAtIndex(forRowAtIndexPath.section).objectForKey("club_logo_B") as! String )
        cell._MatchTeamBLogo.imageFromUrl(imageURLTeamB)
//        rgb(236, 240, 241)
        cell.backgroundColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
    }
    
  
    
}

extension MatchesViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
}

extension MatchesViewController {
    func loadMatchesTableInSeaseon(season:Int ) {
        
        let parameters = ["lang":"ar","season":String(season),"filter":"club"]
        Alamofire.request(.GET, KAPIMatches, parameters: parameters)
            .responseJSON { _, _, JSON, _ in
                
                self.matchesArray=NSArray(array: (JSON?.objectForKey("matches")) as! [AnyObject])
                
                self.matchesTable.reloadData()
        }
    }
    
    
}