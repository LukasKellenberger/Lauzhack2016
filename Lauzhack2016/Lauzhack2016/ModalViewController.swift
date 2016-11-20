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
    
    @IBOutlet weak var productName: UINavigationItem!
    
    @IBOutlet weak var problemText: UILabel!


    @IBOutlet weak var allergiesHeader: UILabel!

    @IBOutlet weak var alergies: UIStackView!
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    @IBOutlet weak var ingredent: UILabel!
    
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
        // print(Allergens.sharedInstance.allergens)
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
            setProduct()
        } else {
            problemText.text = "We don't have enough information on this product!"
        }
    }
    
    func setProduct() {

        productName.title = product.name!
        
        allergiesHeader.isHidden = false
        
        problemText.isHidden = true
        
        setAllergies()
        
        ingredientLabel.isHidden = false
        
        ingredent.isHidden = false
        ingredent.lineBreakMode = .byWordWrapping
        ingredent.numberOfLines = 0
        let alergens: Set<String> = ["Zucker", "Aroma"]
        setIngredients(ingredients: product.ingredients!, alergens: alergens)
        
        
    }
    
    func setAllergies() {
        
    }
    
    func setIngredients(ingredients: Array<String>, alergens: Set<String>) {
        let ingredientString = ingredients.joined(separator: ", ")
        let attribute = NSMutableAttributedString.init(string: ingredientString)
        let ingredientNSString = (ingredientString as NSString)
        for alergen in alergens {
            let range = ingredientNSString.range(of: alergen)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        }
        ingredent.attributedText = attribute

    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
