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

class NewsViewController: UIViewController {

    
    @IBOutlet weak var FCNewsTable: UITableView!
    var postsArray : NSMutableArray?
    var currentPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.FCNewsTable.delegate = self
        self.FCNewsTable.dataSource = self
        
 
        self.setupMenu(["أخبار","ترتيب الفرق","مباريات"])
        self.loadNewsWithPage(self.currentPage)
        self.FCNewsTable.addInfiniteScrollingWithActionHandler { () -> Void in
            self.FCNewsTable.showsInfiniteScrolling = true
            self.currentPage++
            self.loadNewsWithPage(self.currentPage)
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
            switch (indexPath){
            case 0 :
                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NewsViewController") as! UIViewController
                self.navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LeagueTableViewController") as! UIViewController
                self.navigationController?.pushViewController(controller, animated: true)
            case 2:
                let controller : UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MatchesViewController") as! UIViewController
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                println("Default")
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
    
    
}

extension NewsViewController {
    func loadNewsWithPage(page:Int){
    
        let parameters = ["lang":"ar","page":String(page)]
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
