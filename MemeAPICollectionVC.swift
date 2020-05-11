//
//  MemeAPICollectionVC.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 11.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit

class MemeAPICollectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    var memeNames: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeAPICell")
        cell?.textLabel?.text = memeNames[indexPath.row]
        return cell!
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.reloadData()
        // Do any additional setup after loading the view.
    }
    

  

}
