//
//  SelectCountryVC.swift
//  Taxiappz
//
//  Created by Apple on 26/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit

class SelectCountryVC: UIViewController {
    
    private let countryView = SelectCountryView()
    
    weak var delegate:CountryPickerDelegate?
    
    var countryList = [CountryList]()
    var filteredCountryList = [CountryList]()
    var selectedCountry: CountryList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        self.filteredCountryList = self.countryList
        setupViews()
    }
    
    func setupViews() {
        countryView.setupViews(Base: self.view, controller: self)
        
    
        countryView.tblCountry.delegate = self
        countryView.tblCountry.dataSource = self
        countryView.tblCountry.register(CountryPickerCell.self, forCellReuseIdentifier: "CountryPickerCell")
        countryView.tblCountry.sectionIndexColor = .themeColor
        countryView.tblCountry.reloadData()
        countryView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        countryView.txtSearch.addTarget(self, action: #selector(searchText(_ :)), for: .editingChanged)
       
    }

    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
     @objc func searchText(_ sender: UITextField) {
        if let txt = sender.text {
            if txt.count > 0 {
                
                self.filteredCountryList = self.countryList.filter({ $0.countryName?.localizedCaseInsensitiveContains(txt) ?? false || $0.dialCode?.localizedCaseInsensitiveContains(txt) ?? false })
                countryView.tblCountry.reloadData()
            } else {
                self.filteredCountryList = self.countryList
                countryView.tblCountry.reloadData()
                
            }
        }
        
    }

}

extension SelectCountryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryPickerCell") as? CountryPickerCell ?? CountryPickerCell()
        cell.countryNameLbl.text = self.filteredCountryList[indexPath.row].countryName
        cell.isoCodeLbl.text = self.filteredCountryList[indexPath.row].dialCode
        cell.flagImgView.image = self.filteredCountryList[indexPath.row].flag
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCountry(self.filteredCountryList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}


