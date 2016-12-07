//
//  CustomTabBarController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 11/13/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        
        let selectedStateImages = ["pin-map-7.png", "babysitter50", "profile-filled.png"]
        
        let unselectedStateImages = ["pin-map-7.png", "babysitter-plain", "profile-edit.png",]
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = selectedStateImages[i]
                let imageNameForUnselectedState = unselectedStateImages[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let fontName = UIFont(name: "Avenir Next", size: 11) ?? UIFont.systemFont(ofSize: 11)
        
        let selectedColor   = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        let unselectedColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: fontName], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)

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
