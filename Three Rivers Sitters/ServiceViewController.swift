//
//  ServiceViewController.swift
//  ThreeRiversSitters
//
//  Created by Shrinath on 12/8/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {
    
    
    @IBOutlet weak var serviceImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serviceImage.layer.cornerRadius = self.serviceImage.frame.size.width / 2
        self.serviceImage.layer.borderWidth = 2
        self.serviceImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
