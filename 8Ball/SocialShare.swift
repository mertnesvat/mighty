//
//  SocialShare.swift
//  8Ball
//
//  Created by Mert Nesvat on 10/9/18.
//  Copyright © 2018 Mert Nesvat. All rights reserved.
//
import Foundation
import UIKit

protocol SocialShare {
    func instagramBackgroundImage(image: NSData, attributionURL: NSString)
}

extension SocialShare {
    func instagramBackgroundImage(image: NSData, attributionURL: NSString){
        let urlScheme = NSURL.init(string: "instagram-stories://share")
        
        if UIApplication.shared.canOpenURL(urlScheme!.absoluteURL!) {
            
            let pasteboardItems : [[String: Any]] = [["com.instagram.sharedSticker.backgroundImage": image, "com.instagram.sharedSticker.contentURL": attributionURL]]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : NSDate.init().addingTimeInterval(60 * 5)]
            
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            
            UIApplication.shared.open(urlScheme as! URL, options:[:]) { (result) in
                print("result = ()")
                
            }
            
        }
    }
}
