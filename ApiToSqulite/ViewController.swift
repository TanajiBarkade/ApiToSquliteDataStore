//
//  ViewController.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SquliteContainerView: UIView!
    @IBOutlet weak var ServerContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func dataModeSegmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0 : SquliteContainerView.isHidden = false
            ServerContainerView.isHidden = true
            
        case 1 : SquliteContainerView.isHidden = true
            ServerContainerView.isHidden = false
            
        default:
            SquliteContainerView.isHidden = true
                ServerContainerView.isHidden = false
        }
    }
    
}

