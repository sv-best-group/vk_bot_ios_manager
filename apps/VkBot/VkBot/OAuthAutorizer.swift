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


class OAuthAutorizer {
    
    static func tokenOperation(vc: UIViewController) -> Operation<String, NSError> {
        return Operation {[weak vc](observer: Observer<OperationEvent<String, NSError>>) -> Disposable in
            guard let vc = vc else {
                observer.failure(InterruptedError(description: ""))
                return NotDisposable
            }
            let optionalUrl = NSURL(string: "http://google.com")
            
            guard let url = optionalUrl else {
                observer.failure(CreateUrlError(description: ""))
                return NotDisposable
            }
            let safariVC = SFSafariViewController(URL: url)
            
            vc.presentViewController(safariVC, animated: true, completion: nil)
            observer.next("Hello!")
            observer.completed()
            return NotDisposable
        }
    }
}