//
//  DetailViewController.swift
//  JsonGcdDemo
//
//  Created by qingjiezhao on 6/8/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var detailItem = [String : String]()
    
    var webView : WKWebView!

    
    override func loadView() {
        webView = WKWebView()
        self.view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        if let body = detailItem["body"]{
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style> body { font-size : 150%} </style>"
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"
            
            webView.loadHTMLString(html, baseURL: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

