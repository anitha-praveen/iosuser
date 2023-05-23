//
//  TermsAndConditionVC.swift
//  Taxiappz
//
//  Created by Apple on 20/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import WebKit
class TermsAndConditionVC: UIViewController {
    
    private let termsView = TermsAndConditionView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
    }
    
    func setupViews() {
        termsView.setupViews(Base: self.view)
        
        termsView.wkWebView.navigationDelegate = self
        
        termsView.indicatorView.startAnimating()
        termsView.btnBack.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        if let url = URL(string: "") {
            termsView.wkWebView.load(URLRequest(url: url))
        }
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension TermsAndConditionVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        termsView.indicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        termsView.indicatorView.stopAnimating()
    }
    
}
