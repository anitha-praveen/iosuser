//
//  BookForOthersVC.swift
//  Taxiappz
//
//  Created by Apple on 22/03/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import ContactsUI

class BookForOthersVC: UIViewController {

    var bookforaFriendView = BookForOthersView()
    
    var contactTypes = [ContactType]()
    var selectedContactType: ContactType?
    var selectedContact:ContactPerson?
    
    var callBack:((ContactPerson,ContactType)->())?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupviews()
        setupTargets()
        contactTypes = ContactType.allCases
        
        if self.selectedContactType == nil {
            self.selectedContactType = self.contactTypes.first
            self.selectedContact = ContactPerson(selectedContactType?.title ?? "", phone: APIHelper.shared.userDetails?.phone ?? "")
        } else {
            if self.selectedContactType == .others {
                self.bookforaFriendView.contactNameView.isHidden = false
                self.bookforaFriendView.txtContactName.text = self.selectedContact?.name
                self.bookforaFriendView.txtContactNumber.text = self.selectedContact?.phone
            } else {
                self.bookforaFriendView.contactNameView.isHidden = true
            }
        }

        self.bookforaFriendView.choosePassengerTableView.reloadData()
        
    }
    
    func setupviews() {
        
        bookforaFriendView.setupViews(self.view)
        bookforaFriendView.choosePassengerTableView.register(ChoosePassengerTableViewCell.self, forCellReuseIdentifier: "choose")
        bookforaFriendView.choosePassengerTableView.delegate = self
        bookforaFriendView.choosePassengerTableView.dataSource = self
        
        bookforaFriendView.txtContactNumber.delegate = self
    }
    
    func setupTargets() {
        
        bookforaFriendView.btnChooseContact.addTarget(self, action: #selector(chooseContactTapped(_:)), for: .touchUpInside)
        bookforaFriendView.skipButton.addTarget(self, action: #selector(skipBtnPressed(_:)), for: .touchUpInside)
        bookforaFriendView.continueButton.addTarget(self, action: #selector(continueBtnPressed(_:)), for: .touchUpInside)
        
    }
    
    
    
    @objc func chooseContactTapped(_ sender: UIButton) {
        presentContactPicker()
    }
    
    @objc func skipBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func continueBtnPressed(_ sender: UIButton) {
        
        if self.selectedContactType == .others {
            if self.bookforaFriendView.txtContactName.text == "" {
                self.showAlert("", message: "txt_enter_contact_name".localize())
            } else if self.bookforaFriendView.txtContactNumber.text == "" {
                self.showAlert("", message: "txt_enter_contact_number".localize())
            } else if (self.bookforaFriendView.txtContactNumber.text?.count ?? 0) < 10 {
                self.showAlert("", message: "txt_invalid_contact_number".localize())
            } else {
                self.selectedContact = ContactPerson(self.bookforaFriendView.txtContactName.text ?? "", phone: self.bookforaFriendView.txtContactNumber.text ?? "")
                if let contact = self.selectedContact,let contactType = self.selectedContactType {
                    self.dismiss(animated: true) {
                        self.callBack?(contact, contactType)
                    }
                }
            }
        } else {
            self.selectedContact = ContactPerson(selectedContactType?.title ?? "", phone: APIHelper.shared.userDetails?.phone ?? "")
            if let contact = self.selectedContact,let contactType = self.selectedContactType {
                self.dismiss(animated: true) {
                    self.callBack?(contact, contactType)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let touchedView = touch.view {
            if touchedView == self.view {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

//MARK: - TABLE DELEGATE
extension BookForOthersVC: UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choose") as? ChoosePassengerTableViewCell ?? ChoosePassengerTableViewCell()
        cell.chooseLabel.text = self.contactTypes[indexPath.row].title
        cell.selectionStyle = .none
        
        if self.selectedContactType == self.contactTypes[indexPath.row] {
            cell.chooseIconView.isHidden = false
        } else {
            cell.chooseIconView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContactType = self.contactTypes[indexPath.row]
        bookforaFriendView.choosePassengerTableView.reloadData()
        
        if self.selectedContactType == .others {
            self.bookforaFriendView.contactNameView.isHidden = false
        } else {
            self.bookforaFriendView.contactNameView.isHidden = true
        }
        
    }
    
    func presentContactPicker() {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let numbers = contact.phoneNumbers
        let phoneNumber = numbers.first?.value.stringValue
       
        self.selectedContact = ContactPerson(contact.givenName, phone: phoneNumber ?? "")
        self.dismiss(animated: true)
        if let contact = self.selectedContact,let contactType = self.selectedContactType {
            self.dismiss(animated: true) {
                self.callBack?(contact, contactType)
            }
        }
        
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
}

//MARK: - TEXTFIELD DELEGATES

extension BookForOthersVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.bookforaFriendView.txtContactNumber {
            
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let maxLength = 10
                let currentString: NSString = self.bookforaFriendView.txtContactNumber.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                
                return newString.length <= maxLength
            } else {
                return false
            }
        
        }
        
        return true
    }
}


struct ContactPerson {
    var name: String?
    var phone: String?
    
    init(_ name: String, phone: String) {
        self.name = name
        self.phone = phone
    }
}
enum ContactType: CaseIterable {
    case myself
    case others

    var title: String {
        switch self {
        case .myself:
            return "txt_Myself".localize().uppercased()
        case .others:
            return "txt_Other".localize().uppercased()
        }
    }
}
