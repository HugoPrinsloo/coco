//
//  ViewController.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/03/31.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var db: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Database.database().reference().child("Test").child("currentState")
        db?.setValue("Let's Start")
        db?.observe(DataEventType.value, with: { (snap) in
            self.label.text = "\(String(describing: snap.value!))"
        })
    }

    @IBAction func cocoButtonTapped(_ sender: UIButton) {
        db?.setValue("Coco")
    }
    
    @IBAction func awesomeButtonTapped(_ sender: UIButton) {
        db?.setValue("is Awesome")
    }
}

