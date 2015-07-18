//
//  APICommunicator.swift
//  Fateh Club
//
//  Created by Mohamed EL Meseery on 7/17/15.
//  Copyright (c) 2015 Mohamed EL Meseery. All rights reserved.
//

import Foundation
import Alamofire
class APICommunicator: NSObject {
    
    
    class var sharedInstance :  APICommunicator {
        struct Singleton {
            static let instance = APICommunicator()
        }
        
        return Singleton.instance
    }

    func fetchNews (){
    
    
    }
}
