//
//  SentMemeTableVC.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 05.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit

class SentMemeTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
 
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemeCell")
        
        let data = self.memes[(indexPath as NSIndexPath).row]
        
        //Why Optionals are forced?
        cell?.textLabel?.text = data.botText
        
        return cell!
    }
    
    
    //Button for Testing if Array Contains Data which Works
    @IBAction func countButton(_ sender: Any) {
        let data = self.memes[0]
        print(data.botText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
