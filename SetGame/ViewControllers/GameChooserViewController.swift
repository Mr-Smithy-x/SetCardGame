//
//  GameChooserViewController.swift
//  SetGame
//
//  Created by Charlton Smith on 10/31/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

class GameChooserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "one":
            if let vc = segue.destination as? EnhancedViewController {
                vc.players = 1
                print("ONE")
            }
            break
        case "two":
            if let vc = segue.destination as? EnhancedViewController {
                vc.players = 2
            }
            break
        case "old":
            break
        default:
            break
        }
    }
    
}
