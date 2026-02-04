//
//  ModeViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/18.
//

import UIKit

class ModeViewController: UIViewController {
    
    //var appsetting: AppSetting!
    
    @IBOutlet var chooseButton: UIButton! {
        didSet {
            chooseButton.isHighlighted = false
        }
    }
    
    @IBAction func changeButtonTapped(sender: UIButton) {
        
        let darkmodeController = UIAlertController(title: "", message: "選擇您的主題配色", preferredStyle: .actionSheet)
        
        let darkAction = UIAlertAction(title: "深色模式", style: .default, handler: { (action) in
            
            mode = "dark"
            let selectedMode = "dark"
            UserDefaults.standard.set(selectedMode, forKey: "themeMode")
            self.overrideUserInterfaceStyle = .dark
            let window = UIApplication.shared.windows.first
            
            window?.overrideUserInterfaceStyle = .dark
            
            self.chooseButton.setTitle("深色模式", for: .normal)
            
        })
        
        let lightAction = UIAlertAction(title: "淺色模式", style: .default, handler: { (action) in
            
            mode = "light"
            let selectedMode = "light"
            UserDefaults.standard.set(selectedMode, forKey: "themeMode")
            self.overrideUserInterfaceStyle = .light
            let window = UIApplication.shared.windows.first
            
            window?.overrideUserInterfaceStyle = .light
            
            self.chooseButton.setTitle("淺色模式", for: .normal)
            
        })
        
        darkmodeController.addAction(darkAction)
        darkmodeController.addAction(lightAction)
        
        present(darkmodeController,animated: true, completion: nil)
        
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNeedsStatusBarAppearanceUpdate()
        
        if mode == "light" {
            
            navigationController?.navigationBar.overrideUserInterfaceStyle = .light
            tabBarController?.tabBar.overrideUserInterfaceStyle = .light
            overrideUserInterfaceStyle = .light
            setNeedsStatusBarAppearanceUpdate()
            chooseButton.setTitle("淺色模式", for: .normal)
            
        } else if mode == "dark" {
            
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
            tabBarController?.tabBar.overrideUserInterfaceStyle = .dark
            setNeedsStatusBarAppearanceUpdate()
            chooseButton.setTitle("深色模式", for: .normal)
            
        }
    }
    
    


    

}
