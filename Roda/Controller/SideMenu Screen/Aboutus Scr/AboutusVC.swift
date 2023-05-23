//
//  AboutusVC.swift
//  Roda
//
//  Created by Apple on 13/05/22.
//

import UIKit

class AboutusVC: UIViewController {

    let aboutView = AboutusView()
    
    private var aboutusList = [AboutusList]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.aboutusList = AboutusList.allCases
        aboutView.setupViews(Base: self.view)
        aboutView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        setupDelegates()
    }
    

    func setupDelegates() {
        aboutView.tblview.delegate = self
        aboutView.tblview.dataSource = self
        aboutView.tblview.register(UITableViewCell.self, forCellReuseIdentifier: "aboutuscell")
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - TABLE DELEGATES
extension AboutusVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aboutusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutuscell") ?? UITableViewCell()
        
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.appMediumFont(ofSize: 15)
        
        cell.textLabel?.text = self.aboutusList[indexPath.row].title
        cell.imageView?.image = self.aboutusList[indexPath.row].icon
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.aboutusList[indexPath.row] == .rateApp {
            if let url = URL(string: "") {
                UIApplication.shared.open(url)
            }
        } else if self.aboutusList[indexPath.row] == .facebook {
        
            if let url = URL(string: "") {
                UIApplication.shared.open(url)
            }
        } else if self.aboutusList[indexPath.row] == .legal {
            
            if let url = URL(string: "") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
