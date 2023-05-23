//
//  DriverNotesVC.swift
//  Roda
//
//  Created by Apple on 03/06/22.
//

import UIKit

class DriverNotesVC: UIViewController {

    private let notesView = DriverNotesView()
    
    var callBack:((String)->Void)?
    var txtViewPlaceHolder = "hint to driver"
    override func viewDidLoad() {
        super.viewDidLoad()

        notesView.setupViews(Base: self.view)
        notesView.txtView.text = txtViewPlaceHolder
        notesView.txtView.delegate = self
        notesView.btnSubmit.addTarget(self, action: #selector(btnSubmitPressed(_ :)), for: .touchUpInside)
        notesView.btnClose.addTarget(self, action: #selector(btnClosePressed(_ :)), for: .touchUpInside)
        
    }
    
    @objc func btnSubmitPressed(_ sender: UIButton) {
        if notesView.txtView.text == self.txtViewPlaceHolder || notesView.txtView.text == "" {
            self.showAlert("", message: "txt_enter_notes_to_driver".localize())
        } else {
            self.dismiss(animated: true) {
                self.callBack?(self.notesView.txtView.text)
            }
        }
    }
    
    @objc func btnClosePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension DriverNotesVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == txtViewPlaceHolder {
            textView.text = ""
            textView.textColor = UIColor.txtColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  txtViewPlaceHolder
            textView.textColor = .gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
}
