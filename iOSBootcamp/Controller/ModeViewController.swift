//
//  ModeViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit

class ModeViewController: UIViewController {
    
    var appsetting: AppSetting!
    
    @IBOutlet var chooseButton: UIButton!
    
    @IBAction func changeButtonTapped(sender: UIButton) {
        
        let darkmodeController = UIAlertController(title: "", message: "選擇您的主題配色", preferredStyle: .actionSheet)
        
        let darkAction = UIAlertAction(title: "深色模式", style: .default, handler: { (action) in
            
            mode = "dark"
            self.overrideUserInterfaceStyle = .dark
            
        })
        
        let lightAction = UIAlertAction(title: "淺色模式", style: .default, handler: { (action) in
            
            mode = "light"
            self.overrideUserInterfaceStyle = .light
            
        })
        
        darkmodeController.addAction(darkAction)
        darkmodeController.addAction(lightAction)
        
        present(darkmodeController,animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if mode == "light" {
            overrideUserInterfaceStyle = .light
        } else if mode == "dark" {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    


    

}
