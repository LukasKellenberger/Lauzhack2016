//
//  ModalViewController.swift
//  Lauzhack2016
//
//  Created by ire on 19/11/16.
//  Copyright © 2016 gli. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    var code: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
