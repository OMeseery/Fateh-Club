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
   
    var parentNavigationController : UINavigationController?
    
    var postsArray : NSMutableArray?
    var currentPage : Int = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.FCNewsTable.delegate = self
        self.FCNewsTable.dataSource = self
        
        let lang =  NSUserDefaults.standardUserDefaults().objectForKey("language") as! String

        self.loadNewsWithPage(self.currentPage, Language:lang)
        self.FCNewsTable.addInfiniteScrollingWithActionHandler { () -> Void in
            self.currentPage++
            self.loadNewsWithPage(self.currentPage, Language:lang)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        (controller as! PostViewController).postImage = (self.FCNewsTable.cellForRowAtIndexPath(indexPath) as! NewsTableCell ).FCNewsImage.image
        
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    
}

extension NewsViewController {
    func loadNewsWithPage(page:Int ,Language lang:String){
     SwiftSpinner.show("Loading Data ...")
        let parameters = ["lang":lang,"page":String(page)]
        Alamofire.request(.GET, KAPINews, parameters: parameters)
            .responseJSON { _, _, JSON, _ in
            SwiftSpinner.hide(completion: { () -> Void in
                if self.postsArray?.count > 0 {
                    self.postsArray?.addObjectsFromArray((JSON?.objectForKey("posts") as! NSArray) as [AnyObject])
                    
                }else{
                    self.postsArray=NSMutableArray(array: (JSON?.objectForKey("posts")) as! [AnyObject])
                }
                self.FCNewsTable.reloadData()
            })
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
