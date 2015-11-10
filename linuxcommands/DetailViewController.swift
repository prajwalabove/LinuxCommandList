//
//  DetailViewController.swift
//  linuxcommands
//
//  Created by Prajwal on 10/11/15.
//  Copyright © 2015 Above Solutions India Pvt Ltd. All rights reserved.
//

import UIKit
let websearchURL:String = "https://www.google.co.in/#q="

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var searchKey:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.searchKey
        self.requestWebSearchWithKey(self.searchKey)
    }
    
    func requestWebSearchWithKey(searchKey:String) {
        let encodedSearchKey = (searchKey+" in linux").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let searchURLString = websearchURL+encodedSearchKey!
        if let url:NSURL = NSURL(string: searchURLString)! {
            let requestObj:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            self.webView.loadRequest(requestObj)
        }
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
}
