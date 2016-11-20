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
                    print(err)
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
            if let ingr = product_json["data"][0]["attributes"]["ingredients"].string {
                ingredients = Product.ingredientTokenizer(string: ingr)
            } else {
                return false
            }


        } else {
            return false
        }
        return true
    }
    
    class func ingredientTokenizer(string: String) -> Array<String> {
        return string.components(separatedBy: ", ")
    }
    
}


class Allergens {
    static let sharedInstance = Allergens()
    var allergens: JSON

    init() {
        let text = try! String(contentsOfFile: Bundle.main.path(forResource: "allergies.json", ofType: "txt")!)
        allergens = JSON(text)
    }
}
