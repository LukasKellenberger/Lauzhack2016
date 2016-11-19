//
//  SettingsViewController.swift
//  Lauzhack2016
//
//  Created by Lukas Kellenberger on 19.11.16.
//  Copyright © 2016 gli. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {

    var settingKey: String = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let ALL_KEY = "all"
    let ALL_DEFAULT = true
    let ALL_INDEX = 0;
    let DEFAULT = false
    let ALLERGY_KEYS = ["gluten", "seafood", "peanuts"]
    
    let settings = UserDefaults.standard

    @IBOutlet weak var ttableView: UITableView!
    
    var allValue: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ttableView.dataSource = self
        ttableView.delegate = self
        
        allValue = loadValue(key: ALL_KEY)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ALLERGY_KEYS.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        let index = indexPath.row
        
        
        let allergyKey = index == 0 ? ALL_KEY : ALLERGY_KEYS[index-1]
        
        let isOn = loadValue(key: allergyKey)
        cell.switch.addTarget(self, action: #selector(SettingsViewController.cellSwitchChanged(row:index, cell:cell)), for: UIControlEvents.valueChanged)
        cell.label?.text = allergyKey
        cell.switch.setOn(isOn, animated: false)
        if(allValue! && indexPath.row != 0) {
            cell.switch.isEnabled = false
        }
        return cell
    }
    
    func cellSwitchChanged(row: Int, cell: SettingsCell) {
        if(row == ALL_INDEX) {
            ttableView.reloadData()
        }
        
        storeValue(key: cell.settingKey, isOn: cell.switch.isOn)
    }
    
    func storeValue(key: String, isOn: Bool) {
        #imageLiteral(resourceName: "settings").setValue(isOn, forKey: key)
    }
    
    func loadValue(key: String) -> Bool {
        let defaultValue = key == ALL_KEY ? ALL_DEFAULT : DEFAULT
        
        if(settings.object(forKey: key) != nil) {
            return settings.bool(forKey: key)
        } else {
            return defaultValue
        }
    }
}
