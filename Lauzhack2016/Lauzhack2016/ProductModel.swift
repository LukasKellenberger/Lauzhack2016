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
    
    
    init(barcode: String) {
        do {
            let opt = try HTTP.GET("https://www.openfood.ch/api/v1/products?barcodes[]=" + barcode + "&locale=en")
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                //print("data is: \(response.data)") access the response of the data with response.data
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
}
