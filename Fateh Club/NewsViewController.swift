//
//  NewsViewController.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/18/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit
import Alamofire
import BTNavigationDropdownMenu
import CAPSPageMenu

class NewsViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var FCNewsTable: UITableView!
    
    var postsArray : NSMutableArray?
    var currentPage : Int = 1
    var currentLang : String = "ar"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.FCNewsTable.delegate = self
        self.FCNewsTable.dataSource = self
        
 
//        self.setupMenu(["أخبار","ترتيب الفرق","مباريات"])
        self.setupMenu(["عربي","English"])

        self.loadNewsWithPage(self.currentPage, Language:self.currentLang)
        self.FCNewsTable.addInfiniteScrollingWithActionHandler { () -> Void in
            self.FCNewsTable.showsInfiniteScrolling = true
            self.currentPage++
            self.loadNewsWithPage(self.currentPage, Language:self.currentLang)
        }
        // Do any additional setup after loading the view, typically from a nib.
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
//            switch (indexPath){
//            case 0 :
//                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NewsViewController") as! UIViewController
//                self.navigationController?.pushViewController(controller, animated: true)
//            case 1:
//                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LeagueTableViewController") as! UIViewController
//                self.navigationController?.pushViewController(controller, animated: true)
//            case 2:
//                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MatchesViewController") as! UIViewController
//                self.navigationController?.pushViewController(controller, animated: true)
//            default:
//                println("Default")
//            }
      
            switch (indexPath){
            case 0 :
                self.currentLang = "ar"
            case 1:
                self.currentLang = "en"
            default :
                self.currentLang = "ar"
            }
        }
    }
    
}
extension NewsViewController : UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewsTableCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: NewsTableCell, forRowAtIndexPath: NSIndexPath) {
        cell.FCNewsTitle.text = self.postsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("title") as? String
        cell.FCNewsDate.text = self.postsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("date") as? String
        let imageURL = self.postsArray?.objectAtIndex(forRowAtIndexPath.row).objectForKey("thumbnail") as? String
        cell.FCNewsImage.imageFromUrl(imageURL)
    }
}

extension NewsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("PostViewController") as! UIViewController
        (controller as! PostViewController).postTitle = self.postsArray?.objectAtIndex(indexPath.row).objectForKey("title") as? String
        (controller as! PostViewController).postDate = self.postsArray?.objectAtIndex(indexPath.row).objectForKey("date") as? String
        (controller as! PostViewController).postDetails = self.postsArray?.objectAtIndex(indexPath.row).objectForKey("content") as? String
        (controller as! PostViewController).postImage = (self.FCNewsTable.cellForRowAtIndexPath(indexPath) as! NewsTableCell ).FCNewsImage.image!
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension NewsViewController {
    func loadNewsWithPage(page:Int ,Language lang:String){
    
        let parameters = ["lang":lang,"page":String(page)]
        Alamofire.request(.GET, KAPINews, parameters: parameters)
            .responseJSON { _, _, JSON, _ in
                if self.postsArray?.count > 0 {
                self.postsArray?.addObjectsFromArray((JSON?.objectForKey("posts") as! NSArray) as [AnyObject])
                
                }else{
                self.postsArray=NSMutableArray(array: (JSON?.objectForKey("posts")) as! [AnyObject])
                }
                self.FCNewsTable.reloadData()
        }
    }

}

extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        if urlString == nil {
            return
        }
        if let url = NSURL(string: urlString!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                self.image = UIImage(data: data)
            }
        }
    }
}
