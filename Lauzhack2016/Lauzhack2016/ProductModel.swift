//
//  ProductModel.swift
//  Lauzhack2016
//
//  Created by ire on 19/11/16.
//  Copyright © 2016 gli. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHTTP

class Product {
    var product_json: JSON = JSON(data: Data())
    var loaded: Bool = false
    var name: String?
    var ingredients: Array<String>?
    
    
    init(barcode: String, on_load: @escaping (() -> Void)) {
        do {
            let opt = try HTTP.GET("https://www.openfood.ch/api/v1/products?barcodes[]=" + barcode + "&locale=en")
            
            opt.start { response in
                if let err = response.error {
                    on_load()
                }
                self.product_json =  JSON(data: response.data)
                self.loaded = true
                on_load()
            }
        } catch {
            return
        }
    }
    
    func hasBeenFound() -> Bool {
        return product_json["data"][0].exists()
    }
    
    func hasData() -> Bool {
        if (product_json["data"][0]["attributes"]["name"].exists() && product_json["data"][0]["attributes"]["name"].string != nil) {
            name = product_json["data"][0]["attributes"]["name"].stringValue
        } else {
            return false
        }
        if (product_json["data"][0]["attributes"]["ingredients"].exists()) {
            ingredients = product_json["data"][0]["attributes"]["name"].arrayValue
        } else {
            return false
        }
        return true
    }
    
}


class Allergens {
    static let sharedInstance = Allergens()
    var allergens: JSON

    init() {
        let text = try! String(contentsOfFile: Bundle.main.path(forResource: "allergies", ofType: "json")!)
        allergens = JSON(text)
    }
    
    var allergies: Array<String> = ["soya", "gluten", "blé", "lait", "crustacés", "oeufs", "arachides", "noix", "moutarde", "sésame"]
    
    func isAllergen(ingredient: String) -> Array<String> {
        var allergen_array: Array<String> = Array()
        for (key, subJson):(String, JSON) in allergens {
            for (_, subsubJson):(String, JSON) in subJson {
                if (ingredient == subsubJson.string) {
                    allergen_array.append(key)
                }
            }
        }
        return allergen_array
    }
    
    func getProductAllergies(product: Product) -> Dictionary<String, Array<String>> {
        var productAllergies: Dictionary<String, Array<String>> = [String: Array<String>]()
        for allergy in allergies {
            productAllergies[allergy] = []
        }
        
        for ingredient in product.ingredients! {
            for allerg in isAllergen(ingredient: ingredient) {
                productAllergies[allerg]?.append(ingredient)
            }
        }
        
        return productAllergies
    }
}
