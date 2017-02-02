//
//  SentMemesTableTableViewController.swift
//  MemeMe
//
//  Created by Flavio Kreis on 26/01/17.
//  Copyright © 2017 Flavio Kreis. All rights reserved.
//

import UIKit

class SentMemesTableTableViewController: UITableViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // reload collection to ensure all memes are displayed
        tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath)

        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meme = memes[indexPath.row]
        
        performSegue(withIdentifier: "ShowDetailFromList", sender: meme)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailFromList" {
            if let destinationCV = segue.destination as? MemeDetailViewController {
                destinationCV.meme = sender as! Meme
            }
        }
    }

}
