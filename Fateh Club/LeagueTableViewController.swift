//
//  LeagueTableViewController.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/18/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit
import Alamofire

class LeagueTableViewController: UIViewController {
    
    @IBOutlet weak var teamsTable : UITableView!
    var teamsArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.teamsTable.dataSource = self;
        self.teamsTable.delegate = self;
        self.teamsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        let nib = UINib(nibName: "LeagueTableCell", bundle: NSBundle.mainBundle())
        self.teamsTable.registerNib(nib, forCellReuseIdentifier: "cell")
        
        let lang =  NSUserDefaults.standardUserDefaults().objectForKey("language") as! String
        self.loadTable(lang)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension LeagueTableViewController : UITableViewDataSource {
    //MARK: UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LeagueTableCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: LeagueTableCell, forRowAtIndexPath: NSIndexPath) {
        cell._teamName.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("club_name") as! String)
        cell._teamRank.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("rank") as! String)
        cell._teamMatchesTotal.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("matches_total") as! String)
        cell._teamMatchesWon.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("matches_won") as! String)
        cell._teamMatchesDraw.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("matches_draw") as! String)
        cell._teamMatchesLost.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("matches_lost") as! String )
        cell._teamGoalsPro.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("goals_pro") as! String )
        cell._teamGoalsagainst.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("goals_against") as! String)
        cell._teamPoints.text = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("points") as! String )
        let imageURL = (self.teamsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("logo") as! String )
        cell._teamLogo.imageFromUrl(imageURL)
    }

}

extension LeagueTableViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NSBundle.mainBundle().loadNibNamed("LeagueTableHeader", owner: self, options: nil)[0]  as! UIView
        return header;
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
}

extension LeagueTableViewController {
    func loadTable (language:String) {
        SwiftSpinner.show("Loading Data ...")
        let parameters = ["lang":language]
        Alamofire.request(.GET, KAPITable, parameters: parameters)
            .responseJSON { _, _, JSON, _ in
                SwiftSpinner.hide(completion: { () -> Void in
                    
                    self.teamsArray=NSArray(array: (JSON?.objectForKey("table")) as! [AnyObject])
                    
                    self.teamsTable.reloadData()
                })
        }
    }


}