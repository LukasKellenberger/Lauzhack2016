//
//  ModalViewController.swift
//  Lauzhack2016
//
//  Created by ire on 19/11/16.
//  Copyright © 2016 gli. All rights reserved.
//

import UIKit

class AllergyCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isAllowedImage: UIImageView!
}

class ModalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var code: String!
    var product: Product!
    var allergies: Array<String> = []
    var productAllergies: Dictionary<String, Array<String>>?
    let settings = UserDefaults.standard
    
    @IBOutlet weak var productName: UINavigationItem!
    @IBOutlet weak var problemText: UILabel!
    @IBOutlet weak var allergiesHeader: UILabel!
    @IBOutlet weak var alergiesTableView: UITableView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var ingredent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = Product(barcode: "80135463", on_load: {
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
        alergiesTableView.dataSource = self
        alergiesTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func boolFromSettings(key: String, defaultValue: Bool) -> Bool {
        if(settings.object(forKey: key) != nil) {
            return settings.bool(forKey: key)
        } else {
            return defaultValue
        }
    }
    
    func getActivatedAllergies() {
        if(boolFromSettings(key: SettingsViewController.ALL_KEY, defaultValue: SettingsViewController.ALL_DEFAULT)) {
            allergies = Allergens.sharedInstance.allergies
        } else {
            for allergy in Allergens.sharedInstance.allergies {
                let isOn = boolFromSettings(key: allergy, defaultValue: SettingsViewController.DEFAULT)
                if(isOn) {
                    allergies.append(allergy)
                }
            }
        }
    }
    
    func renderFail() {
        problemText.text = "Oooops! There was a problem."
    }
    
    func renderNotFound() {
        problemText.text = "This product is not catalogged!"
    }
    
    func renderProduct() {
        
        if product.hasData() {
            productAllergies = Allergens.sharedInstance.getProductAllergies(product: product)
            getActivatedAllergies()
            setProduct()
        } else {
            problemText.text = "We don't have enough information on this product!"
        }
    }
    
    func setProduct() {

        productName.title = product.name!
        
        allergiesHeader.isHidden = false
        
        problemText.isHidden = true
        
        alergiesTableView.isHidden = false
        alergiesTableView.reloadData()
        
        ingredientLabel.isHidden = false
        
        ingredent.isHidden = false
        ingredent.lineBreakMode = .byWordWrapping
        ingredent.numberOfLines = 0
        setIngredients(ingredients: product.ingredients!, alergens: [])
        
        
    }
    
    
    func setIngredients(ingredients: Array<String>, alergens: Array<String>) {
        let ingredientString = ingredients.joined(separator: ", ")
        let attribute = NSMutableAttributedString.init(string: ingredientString)
        let ingredientNSString = (ingredientString as NSString)
        for alergen in alergens {
            let range = ingredientNSString.range(of: alergen)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        }
        ingredent.attributedText = attribute

    }
    
    func isAllowed(allergy: String) -> Bool {
        return productAllergies![allergy]!.isEmpty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allergycell", for: indexPath) as! AllergyCell
        let name = allergies[indexPath.row]
        cell.name.text = name
        cell.imageView?.image = isAllowed(allergy: name) ? #imageLiteral(resourceName: "Yes") : #imageLiteral(resourceName: "No")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = allergies[indexPath.row]
        setIngredients(ingredients: product.ingredients!, alergens: productAllergies![name]!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        setIngredients(ingredients: product.ingredients!, alergens: [])
    }


    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
