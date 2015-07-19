//
//  BaseViewController.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/19/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

let KlanguageChangedNotification = "LanguageChanged"

class BaseViewController: UIViewController {

     var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let NewsController : NewsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NewsViewController") as! NewsViewController
        NewsController.parentNavigationController = self.navigationController
        NewsController.title = "اخبار"
        let LeagueController : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LeagueTableViewController") as! UIViewController
        LeagueController.title = "جدول الدوري"
        let MatchesController : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MatchesViewController") as! UIViewController
        MatchesController.title = "مباريات"
        var controllerArray : [UIViewController] = [NewsController,LeagueController,MatchesController]
        
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        
         self.setupMenu(["عربي","English"])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func setupMenu (items :[String!]) {
        let menuView = BTNavigationDropdownMenu(frame:  CGRectMake(0.0, 0.0, 300, 44), title: items.first!, items: items, containerView: self.view)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.bounceOffset = 5
        
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
//            
            switch (indexPath){
            case 0 :
                NSUserDefaults.standardUserDefaults().setObject("ar", forKey: "language")
            case 1:
                NSUserDefaults.standardUserDefaults().setObject("en", forKey: "language")
            default :
                NSUserDefaults.standardUserDefaults().setObject("ar", forKey: "language")
            }
            self.notifyLanguageChanged()
        }
    }
    
    func notifyLanguageChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(KlanguageChangedNotification, object: self)
    }
}

extension BaseViewController : CAPSPageMenuDelegate {


}
