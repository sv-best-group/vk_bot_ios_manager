//
//  DataViewController.swift
//  VkBot
//
//  Created by Serg on 7/30/16.
//  Copyright © 2016 Serg. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    
    @IBAction func logIn(sender: AnyObject) {
        print("Button is pressed!")
        let operation = OAuthAutorizer.tokenOperation(self)
        operation.observe { (event) in
            switch event {
                
            case .Next(let value):
                print("Value \(value)")
                
            case .Failure(let error):
                print("Error \(error)")
                
            case .Completed:
                break

            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }


}

