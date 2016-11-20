//
//  SettingsViewController.swift
//  Lauzhack2016
//
//  Created by Lukas Kellenberger on 19.11.16.
//  Copyright © 2016 gli. All rights reserved.
//

import Foundation
import UIKit

class UISwitchWithId: UISwitch {
    var key: String?
    
}

class SettingsCell: UITableViewCell {

    var settingKey: String = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitchWithId!
    
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let ALL_KEY = "all"
    static let ALL_DEFAULT = false
    static let ALL_INDEX = 0;
    static let DEFAULT = false
    static let ALLERGY_KEYS = ["gluten", "seafood", "peanuts"]
    
    let settings = UserDefaults.standard

    @IBOutlet weak var ttableView: UITableView!
    
    var allValue: Bool?
    var currentRow: Int?
    var currentCell: SettingsCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ttableView.dataSource = self
        ttableView.delegate = self
        
        allValue = loadValue(key: SettingsViewController.ALL_KEY)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewController.ALLERGY_KEYS.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        let index = indexPath.row
        
        currentRow = index
        currentCell = cell;
        
        let allergyKey = index == 0 ? SettingsViewController.ALL_KEY : SettingsViewController.ALLERGY_KEYS[index-1]
        
        let isOn = loadValue(key: allergyKey)
        cell.settingKey = allergyKey
        cell.switch.key = allergyKey
        cell.switch.addTarget(self, action: #selector(self.switchValueChanged(swch:)), for: UIControlEvents.valueChanged)
        cell.label?.text = allergyKey
        cell.switch.setOn(isOn, animated: false)
        cell.switch.isEnabled = indexPath.row == SettingsViewController.ALL_INDEX || !allValue!

        return cell
    }
    
    func switchValueChanged(swch: UISwitchWithId) {
        let key = swch.key!
        let value = swch.isOn
        
        if(key == SettingsViewController.ALL_KEY) {
            allValue = value
            ttableView.reloadData()
        }
        
        storeValue(key: key, isOn: value)
    }

    func storeValue(key: String, isOn: Bool) {
        settings.setValue(isOn, forKey: key)
    }
    
    func loadValue(key: String) -> Bool {
        let defaultValue = key == SettingsViewController.ALL_KEY ? SettingsViewController.ALL_DEFAULT : SettingsViewController.DEFAULT
        
        if(settings.object(forKey: key) != nil) {
            return settings.bool(forKey: key)
        } else {
            return defaultValue
        }
    }
}
