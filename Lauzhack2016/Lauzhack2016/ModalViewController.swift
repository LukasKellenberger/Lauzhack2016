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
    var product: Product!
    
    @IBOutlet weak var problemText: UILabel!
    @IBOutlet weak var productName: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        product = Product(barcode: code, on_load: {
            if !self.product.loaded {
                DispatchQueue.main.sync {
                    self.renderFail()
                }
            } else {
                DispatchQueue.main.sync {
                    if self.product.hasBeenFound() {
                        self.renderProduct()
                    } else {
                        self.renderNotFound()
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderFail() {
        problemText.text = "Oooops! There was a problem."
    }
    
    func renderNotFound() {
        problemText.text = "This product is not catalogged!"
    }
    
    func renderProduct() {
        if product.hasData() {
            productName.title = product.name!
        } else {
            problemText.text = "We don't have enough information on this product!"
        }
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
