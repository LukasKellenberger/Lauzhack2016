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
    
    func getName() -> String {
        return product_json["data"][0]["attributes"]["name"].string!
    }
    
    func getIngredients() -> Array<Any> {
        return product_json["data"][0]["attributes"]["ingredients"].array!
    }
}
