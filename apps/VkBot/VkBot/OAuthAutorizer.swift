//
//  OAuthAutorizer.swift
//  VkBot
//
//  Created by Serg on 8/3/16.
//  Copyright © 2016 Serg. All rights reserved.
//

import UIKit
import ReactiveKit
import SafariServices

class InterruptedError: NSError {
    init(description: String){
        super.init(domain: "vk", code: 0, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CreateUrlError: NSError {
    init(description: String){
        super.init(domain: "vk", code: 0, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let auth = OAuthAutorizer()
var obs: Observer<OperationEvent<String, NSError>>? = nil

class OAuthAutorizer: NSObject, SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        obs?.failure(InterruptedError(description: ""))
        obs = nil
    }
    
    private override init() {
        super.init()
    }
    
    func tokenOperation(vc: UIViewController) -> Operation<String, NSError> {
        return Operation {[weak vc](observer: Observer<OperationEvent<String, NSError>>) -> Disposable in
            
            guard let vc = vc else {
                observer.failure(InterruptedError(description: ""))
                return NotDisposable
            }
            let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|},:").invertedSet

            
            let components = NSURLComponents()
            
            components.scheme = "https"
            components.host = "oauth.vk.com"
            components.path = "authorize"
            
            var queryItems: [NSURLQueryItem] = []
            
            let item1 = NSURLQueryItem(name: "client_id", value: "5567759")
            queryItems.append(item1)
            
            let item2 = NSURLQueryItem(name: "scope", value: "friends,video,offline".stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet))
            queryItems.append(item2)

            let item3 = NSURLQueryItem(name: "redirect_uri", value: "vk5567759://authorize".stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)) //  vk5567759://vk_bot.com
            queryItems.append(item3)

            let item4 = NSURLQueryItem(name: "response_type", value: "code")
            queryItems.append(item4)

            let item5 = NSURLQueryItem(name: "v", value: "5.53".stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet))
            queryItems.append(item5)
            
            components.queryItems = queryItems
            
            //print("components \(components)")
            
            let optionalUrl = NSURL(string: "https://oauth.vk.com/authorize?\(components.query!)")
            //print("optionalUrl \(optionalUrl)")
            
            guard let url = optionalUrl else {
                observer.failure(CreateUrlError(description: ""))
                return NotDisposable
            }
            
            let safariVC = SFSafariViewController(URL: url)
            safariVC.delegate = self
            obs = observer
            
            vc.presentViewController(safariVC, animated: true, completion: nil)
            // observer.next("Hello!")
            // observer.completed()
            return NotDisposable
        }
    }
}