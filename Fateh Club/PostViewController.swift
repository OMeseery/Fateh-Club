//
//  PostViewController.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/19/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var _PostImage: UIImageView!
    @IBOutlet weak var _PostTitle: UILabel!
    @IBOutlet weak var _PostDate: UILabel!
    @IBOutlet weak var _PostText: UITextView!
    
    var postImage :UIImage?
    var postTitle :String?
    var postDate  :String?
    var postDetails  :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _PostImage.image = postImage
        _PostTitle.text = postTitle
        _PostDate.text = postDate
        _PostText.text = postDetails
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK : - ViewModel
extension PostViewController {
    
    
}
