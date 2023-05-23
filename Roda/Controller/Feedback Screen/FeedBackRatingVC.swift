//
//  FeedBackRatingVC.swift
//  Taxiappz
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import NVActivityIndicatorView
import GoogleMaps

class FeedBackRatingVC: UIViewController {

    let feedbackView = FeedBackRatingView()
    var tripinvoicedetdict = [String:AnyObject]()
    
    var feedbackQuestions = [FeedbackQuestions]()
    
    var selectedFeedbackQuestions = [FeedbackQuestions]()
    var selectedIndexpaths = [IndexPath]()
    
    var txtViewPlaceHolder = "txt_additional_cmt".localize()
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        getFeedbackQuestions()
        
    }
    
    func setupView() {
      
        feedbackView.setupViews(Base: self.view, controller: self)
        feedbackView.tblQuestions.delegate = self
        feedbackView.tblQuestions.dataSource = self
        feedbackView.tblQuestions.register(FeedbackQuestionCell.self, forCellReuseIdentifier: "FeedbackQuestionCell")
        
        feedbackView.btnSubmit.addTarget(self, action: #selector(submitbuttonPressed(_ :)), for: .touchUpInside)
        
        setupData()
    }
    
    func setupData() {
        
        feedbackView.lblHowisTrip.text = "txt_how_is_trip".localize()
        feedbackView.lblHint.text = "txt_feed_desc".localize()
        feedbackView.btnSubmit.setTitle("txt_submit_review".localize(), for: .normal)
        
        
        if let driverdictdet = tripinvoicedetdict["driver"] as? [String:AnyObject] {
            if let firstName = driverdictdet["firstname"] as? String, let lastName = driverdictdet["lastname"] as? String {
                let str = firstName + " " + lastName
                self.feedbackView.lblDriverName.text = str.localizedCapitalized
            }
            
// Using S3
//            if let imgStr = driverdictdet["profile_pic"] as? String {
//                self.retriveImg(key: imgStr) { data in
//                    self.feedbackView.imgProfile.image = UIImage(data: data)
//                }
//            }
            
            if let imgStr = driverdictdet["profile_pic"] as? String, let url = URL(string: imgStr) {
                self.feedbackView.imgProfile.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                self.feedbackView.imgProfile.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        }
        if let carDetails = tripinvoicedetdict["car_details"] as? [String: AnyObject] {
            
            if let carNUm = carDetails["car_number"] as? String {
                feedbackView.lblCarNum.text = carNUm
            }
            if let carModel = carDetails["car_model"] as? String {
                feedbackView.lblCarType.text = carModel
            }
        }
      
    }
   
    @objc func submitbuttonPressed(_ sender: UIButton) {
        
//        if feedbackView.rating.value < 1 {
//            self.showAlert("",message: "txt_rate_driver".localize())
//        } else {
            self.rateDriver()
//        }

    }
    
    
    func getFeedbackQuestions() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
           
            let url = APIHelper.shared.BASEURL + APIHelper.getFeedbackQuestions
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let questions = data["invoice_questions_list"] as? [[String: AnyObject]] {
                                    self.feedbackQuestions = questions.compactMap({FeedbackQuestions($0)})
                                    self.selectedIndexpaths = [[0,0],[0,1],[0,2],[0,3],[0,4]]
                                    self.selectedFeedbackQuestions = self.feedbackQuestions
                                    self.feedbackView.tblQuestions.reloadData()
                                }
                            }
                        } else {
                            if let error = result["data"] as? [String:[String]] {
                                let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                self.showAlert("", message: errMsg)
                            } else if let errMsg = result["error_message"] as? String {
                                self.showAlert("", message: errMsg)
                            } else if let msg = result["message"] as? String {
                                self.showAlert("", message: msg)
                            }
                        }
                    }
                   
            }
        }
    }
    
    func rateDriver() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = tripinvoicedetdict["id"]
            paramDict["rating"] =  String(format: "%.2f", feedbackView.rating.value)
            do {
                let jsonData = try JSONEncoder().encode(self.feedbackQuestions)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    paramDict["question_id"] = jsonString
                }
            } catch { print(error) }
           
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.rateDriver
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Trip Completed"), object: nil)
                            self.navigationController?.view.showToast("txt_rated_successfully".localize())
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            if let error = result["data"] as? [String:[String]] {
                                let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                self.showAlert("", message: errMsg)
                            } else if let errMsg = result["error_message"] as? String {
                                self.showAlert("", message: errMsg)
                            } else if let msg = result["message"] as? String {
                                self.showAlert("", message: msg)
                            }
                        }
                    }
                   
            }
        }
    }
    
    func forceLogout() {
           if let root = self.navigationController?.revealViewController().navigationController {
            
               let firstvc = Initialvc()
                   root.view.showToast("text_already_login".localize())
                   root.setViewControllers([firstvc], animated: false)
            
           }
           AppLocationManager.shared.stopTracking()
           APIHelper.shared.deleteUser()
       }

}

//MARK: TABLEVIEW DELEGATE
extension FeedBackRatingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbackQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackQuestionCell") as? FeedbackQuestionCell ?? FeedbackQuestionCell()
        
        cell.lblQuestion.text = self.feedbackQuestions[indexPath.row].question
        
        cell.btnLike.isSelected = self.selectedIndexpaths.contains(indexPath)
        cell.btnDislike.isSelected = !self.selectedIndexpaths.contains(indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if self.selectedIndexpaths.contains(indexPath) {
            if let index = self.selectedIndexpaths.firstIndex(of: indexPath) {
                self.selectedIndexpaths.remove(at: index)
            }
            if let data = self.selectedFeedbackQuestions.firstIndex(of: self.feedbackQuestions[indexPath.row]) {
                self.selectedFeedbackQuestions.remove(at: data)
            }
            self.feedbackQuestions[indexPath.row].answer = "NO"
        } else {
            self.feedbackQuestions[indexPath.row].answer = "YES"
            self.selectedIndexpaths.append(indexPath)
            self.selectedFeedbackQuestions.append(self.feedbackQuestions[indexPath.row])
        }
        self.feedbackView.tblQuestions.reloadData()
        self.feedbackView.rating.value = CGFloat(self.selectedFeedbackQuestions.count)
        
    }
    
    
}

extension FeedBackRatingVC: UITextViewDelegate {
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
        return numberOfChars < 100
    }
}

/*
class FeedBackRatingVC: UIViewController {

    let feedbackView = FeedBackRatingView()
    var tripinvoicedetdict = [String:AnyObject]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
    }
   
    
    func setupView() {
    
        feedbackView.setupViews(Base: self.view, controller: self)
        feedbackView.commentView.delegate = self
        feedbackView.btnSubmit.addTarget(self, action: #selector(submitbuttonPressed(_ :)), for: .touchUpInside)
        feedbackView.slider.addTarget(self, action: #selector(sliderValueChanged(_ :)), for: .valueChanged)
        setupData()
    }
    
    func setupData() {
        
        feedbackView.lblHowisTrip.text = "txt_how_is_trip".localize().uppercased()
        feedbackView.lblHint.text = "txt_feed_desc".localize()
        feedbackView.commentView.text = " " + "txt_additional_cmt".localize()
        feedbackView.btnSubmit.setTitle("text_submit".localize().uppercased(), for: .normal)
        

    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
        print("positioning at ", sender.value)
        if sender.value >= 1   && sender.value < 2 {
            self.view.backgroundColor = .hexToColor("FFBBBB")
            self.feedbackView.lblRateMode.text = "Very Bad"
            self.feedbackView.imgRateMode.image = UIImage(named: "img_rating_very_bad")
        } else if sender.value >= 2  && sender.value < 3 {
            self.view.backgroundColor = .hexToColor("FFE4C0")
            self.feedbackView.lblRateMode.text = "Not Bad"
            self.feedbackView.imgRateMode.image = UIImage(named: "img_rating_not_bad")
        } else if sender.value >= 3  && sender.value < 4 {
            self.view.backgroundColor = .hexToColor("FFBBBB")
            self.feedbackView.lblRateMode.text = "Good"
            self.feedbackView.imgRateMode.image = UIImage(named: "img_rating_very_bad")
        } else if sender.value >= 4  && sender.value < 5 {
            self.view.backgroundColor = .hexToColor("FFE4C0")
            self.feedbackView.lblRateMode.text = "Very Good"
            self.feedbackView.imgRateMode.image = UIImage(named: "img_rating_not_bad")
        } else if sender.value == 5 {
            self.view.backgroundColor = .hexToColor("FFBBBB")
            self.feedbackView.lblRateMode.text = "Satisfied"
            self.feedbackView.imgRateMode.image = UIImage(named: "img_rating_very_bad")
        }
    }
   
    @objc func submitbuttonPressed(_ sender: UIButton) {
        
        self.rateDriver()

    }
    
    func rateDriver() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = tripinvoicedetdict["id"]
            paramDict["rating"] =  self.feedbackView.slider.value
            if self.feedbackView.commentView.text != "" {
                paramDict["feedback"] = self.feedbackView.commentView.text
            }
           
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.rateDriver
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Trip Completed"), object: nil)
                            self.navigationController?.view.showToast("Rated successfully!")
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            if let error = result["data"] as? [String:[String]] {
                                let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                self.showAlert("", message: errMsg)
                            } else if let errMsg = result["error_message"] as? String {
                                self.showAlert("", message: errMsg)
                            } else if let msg = result["message"] as? String {
                                self.showAlert("", message: msg)
                            }
                        }
                    }
                   
            }
        }
    }
    
    func forceLogout() {
           if let root = self.navigationController?.revealViewController().navigationController {
            
               let firstvc = Initialvc()
                   root.view.showToast("text_already_login".localize())
                   root.setViewControllers([firstvc], animated: false)
            
           }
           AppLocationManager.shared.stopTracking()
           APIHelper.shared.deleteUser()
       }

}
*/
