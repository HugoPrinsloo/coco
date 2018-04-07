//
//  InitialViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/02.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: OriginalOverviewViewController.self))
            let vc = storyboard.instantiateViewController(withIdentifier: "Overview")
            navigationController?.present(vc, animated: true, completion: nil)
        }

    }



}
