//
//  ViewController.swift
//  Demo
//
//  Created by Armin Likic on 22/11/2015.
//  Copyright © 2015 ProgramiranjeOrg. All rights reserved.
//

import UIKit
import SwiftElegantDropdownMenu

class ViewController: UIViewController {
    
    @IBOutlet weak var dropdownMenu: SwiftElegantDropdownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = ["Zeus", "Hades", "Poseidon", "Chronos", "Aphrodite", "Artemis", "Hefestus"]
        self.dropdownMenu.title = items.first!
        self.dropdownMenu.items = items
        self.dropdownMenu.configuration.titleFont = UIFont(name: "Arial", size: 22)!
        
        self.dropdownMenu.configuration.cellTextColor = UIColor.redColor()
        self.dropdownMenu.configuration.cellFont = UIFont(name: "Courier New", size: 18)!
        
        self.dropdownMenu.onItemSelect = {
            
            (index, item) -> () in
            
            print("Selected: \(index) - \(item!)")
            
        }
        
    }
    
}

