//
//  WebViewController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/8/7.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var targetUrl = "https://support.apple.com/itunes"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: targetUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    

    

}
