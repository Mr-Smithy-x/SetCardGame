//
//  ThemeViewController.swift
//  CardGame
//
//  Created by Charlton Smith on 10/5/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController, UISplitViewControllerDelegate {

    private var concentrationGameInstances: [String: ConcentrationViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Theme View Chooser"
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let themeName = (sender as? UIButton)?.currentTitle {
            navigationItem.title = themeName
            if let theme = Concentration.themes[themeName] {
                if(!concentrationGameInstances.keys.contains(theme)) {
                    concentrationGameInstances[theme] = (self.storyboard?.instantiateViewController(identifier: "concentration") as! ConcentrationViewController)
                    concentrationGameInstances[theme]?.theme = theme
                    concentrationGameInstances[theme]?.themeName = themeName
                }
                
                show(concentrationGameInstances[theme]!, sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print(segue.identifier ?? "LOL")
    }
    
}
