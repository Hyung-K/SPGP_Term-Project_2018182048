//
//  ViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var LogoImageView: UIImageView!
    @IBAction func logoTapped(sender: AnyObject) {
        guard let searchScene = self.storyboard?.instantiateViewController(withIdentifier: "Search Scene") else {
            return
        }
        searchScene.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.navigationController?.pushViewController(searchScene, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LogoImageView.image = UIImage(named:"res/bus_animation.gif")
    }


}

