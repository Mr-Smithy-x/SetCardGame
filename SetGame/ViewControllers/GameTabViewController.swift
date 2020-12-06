//
//  TabBarControllerViewController.swift
//  SetGame
//
//  Created by Charlton Smith on 12/5/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import UIKit

class GameTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = tabBarItem.title
        
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationItem.title = item.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
