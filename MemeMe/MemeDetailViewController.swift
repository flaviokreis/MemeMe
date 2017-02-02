//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Flavio Kreis on 02/02/17.
//  Copyright © 2017 Flavio Kreis. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImage.image = meme.memedImage
    }

}
