//
//  HistoryVC.swift
//  Taxiappz
//
//  Created by Apple on 31/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher
class HistoryVC: UIViewController {
    
    let historyView = HistoryView()
    
    private var scheduledPage: Int?
    private var scheduledLastPage: Int?
    private var scheduledList: [HistroyDetail]? = []
    private var completedPage: Int?
    private var completedLastPage: Int?
    private var completedList:[HistroyDetail]? = []
    private var cancelledPage: Int?
    private var cancelledLastPage: Int?
    private var cancelledList:[HistroyDetail]? = []
    
    private var historyDetailList:[HistroyDetail]? = []

    private var historySelectionType: SelectedHistory? = .scheduled

    private var isLoading = false
    
    private var rowTobeCancelled = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViews()
        self.setupTarget()
        self.scheduledPage = 1
        self.gethistorydetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setUpViews() {
        historyView.setupViews(Base: self.view)
    }

    func setupTarget() {
        historyView.historytbv.delegate = self
        historyView.historytbv.dataSource = self
        historyView.historytbv.register(HistoryTableViewCell.self, forCellReuseIdentifier: "historycell")

        historyView.segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)

        historyView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        historyView.btnAlertYes.addTarget(self, action: #selector(btnAlertYesPressed(_ :)), for: .touchUpInside)
        historyView.btnAlertNo.addTarget(self, action: #selector(btnAlertNoPressed(_ :)), for: .touchUpInside)
    }
}

//MARK:- TARGET ACTIONS
extension HistoryVC {
    
    @objc func segmentAction(_ sender: UISegmentedControl) {
        self.historyDetailList?.removeAll()
        self.historyView.historytbv.reloadData()
        if sender.selectedSegmentIndex == 0 {
            
            self.historySelectionType = .scheduled
            if let list = self.scheduledList, !list.isEmpty {
                self.historyDetailList = list
                self.historyView.historytbv.reloadData()
                self.historyView.historytbv.isHidden = false
            } else {
                self.scheduledPage = 1
                self.gethistorydetails()
            }
            
        } else if sender.selectedSegmentIndex == 1 {
            
            self.historySelectionType = .completed
            if let list = self.completedList, !list.isEmpty {
                self.historyDetailList = list
                self.historyView.historytbv.reloadData()
                self.historyView.historytbv.isHidden = false
            } else {
                self.completedPage = 1
                self.gethistorydetails()
            }
            
        } else if sender.selectedSegmentIndex == 2 {
            
            self.historySelectionType = .cancelled
            if let list = self.cancelledList, !list.isEmpty {
                self.historyDetailList = list
                self.historyView.historytbv.reloadData()
                self.historyView.historytbv.isHidden = false
            } else {
                self.cancelledPage = 1
                self.gethistorydetails()
            }
            
        }
        
    }
    
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.scheduledPage = nil
        self.completedPage = nil
        self.cancelledPage = nil
        self.scheduledList = nil
        self.completedList = nil
        self.cancelledList = nil
        self.historyDetailList = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func btnAlertYesPressed(_ sender: UIButton) {
        self.cancelScheduleTrip(self.historyDetailList?[self.rowTobeCancelled].id ?? "")
    }
    @objc func btnAlertNoPressed(_ sender: UIButton) {
        self.historyView.cancelAlertView.isHidden = true
    }
  
}

//MARK: API'S
extension HistoryVC {
    func gethistorydetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            isLoading = true
            if self.historySelectionType == .scheduled {
                paramDict["trip_type"] = "ALL"
                paramDict["ride_type"] = "RIDE LATER"
                paramDict["page"] = self.scheduledPage
            } else if self.historySelectionType == .completed {
                paramDict["trip_type"] = "COMPLETED"
                paramDict["ride_type"] = "RIDE NOW"
                paramDict["page"] = self.completedPage
            } else if self.historySelectionType == .cancelled {
                paramDict["trip_type"] = "CANCELLED"
                paramDict["ride_type"] = "RIDE NOW"
                paramDict["page"] = self.cancelledPage
            }
            let url = APIHelper.shared.BASEURL + APIHelper.getHistoryList
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                self.isLoading = false
                switch response.result {
                case .failure(let error):
                    self.isLoading = false
                    self.noDataAvailable("txt_history_empty".localize())
                    self.view.showToast(error.localizedDescription)
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let dataList = result["data"] as? [String: AnyObject] {
                                if let data = dataList["data"] as? [[String: AnyObject]] {
                                    
                                    if self.historySelectionType == .scheduled {
                                        
                                        self.scheduledList?.append(contentsOf: data.compactMap({HistroyDetail($0)}))
                                        if let list = self.scheduledList {
                                            self.historyDetailList = list
                                        }
                                    } else if self.historySelectionType == .completed {
                                        
                                        self.completedList?.append(contentsOf: data.compactMap({HistroyDetail($0)}))
                                        if let list = self.completedList {
                                            self.historyDetailList = list
                                        }
                                    } else if self.historySelectionType == .cancelled {
                                        
                                        self.cancelledList?.append(contentsOf: data.compactMap({HistroyDetail($0)}))
                                        if let list = self.cancelledList {
                                            self.historyDetailList = list
                                        }
                                    }
                                    
                                    if let lastPageNumber = dataList["last_page"] as? Int {
                                        if self.historySelectionType == .scheduled {
                                            self.scheduledLastPage = lastPageNumber
                                        } else if self.historySelectionType == .completed {
                                            self.completedLastPage = lastPageNumber
                                        } else if self.historySelectionType == .cancelled {
                                            self.cancelledLastPage = lastPageNumber
                                        }
                                    }
                                    
                                    if self.historyDetailList?.count == 0 {
                                        self.noDataAvailable("txt_history_empty".localize())
                                    } else {
                                        self.historyView.historytbv.reloadData()
                                        self.historyView.historytbv.isHidden = false
                                    }
                                }
                            }
                        } else {
                            self.noDataAvailable("txt_history_empty".localize())
                        }
                    }
                }
                
            }
        }
    }
    
    func noDataAvailable(_ msg: String) {
       
        self.historyView.imgNoRides.isHidden = false
        self.historyView.lblNoRides.isHidden = false
        
        self.historyView.historytbv.isHidden = true
    }
}

//MARK:- TABLE DELEGATES
extension HistoryVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyDetailList?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        if let vehicleNumber = self.historyDetailList?[indexPath.row].carDetail?.carNumber {
            cell.lblVehicleNumber.text = vehicleNumber
        } else {
            cell.lblVehicleNumber.text = "-- -- - ----"
        }
        if let rating = self.historyDetailList?[indexPath.row].driverRating {
            cell.ratingLbl.set(text: rating, with: UIImage(named: "star"))
        } else {
            cell.ratingLbl.set(text: "0.00", with: UIImage(named: "star"))
        }
        if let fName = self.historyDetailList?[indexPath.row].driverDetail?.firstName {
            cell.drivernamelbl.text = fName
        } else {
            cell.drivernamelbl.text = "---------"
        }
        
        if let reqId = self.historyDetailList?[indexPath.row].requestId {
            cell.lblRequestNumber.text = reqId
        }
        if let typeName = self.historyDetailList?[indexPath.row].typeName {
            if let model = self.historyDetailList?[indexPath.row].carDetail?.carModel {
                cell.lblVehicleTypeName.text = typeName + " | " + model
            } else {
                cell.lblVehicleTypeName.text = typeName
            }
        }
        
        
        if let vehicleImage = self.historyDetailList?[indexPath.row].vehicleHighLightImage {
            if let url = URL(string: vehicleImage) {
                let resource = ImageResource(downloadURL: url)
                cell.vehicleImageView.kf.setImage(with: resource)
            }
        } else if let img = self.historyDetailList?[indexPath.row].vehicleImage {
            if let url = URL(string: img) {
                let resource = ImageResource(downloadURL: url)
                cell.vehicleImageView.kf.setImage(with: resource)
            }
        }
        
// Using S3
//        if let imgStr = historyDetailList?[indexPath.row].driverDetail?.userProfilePicUrlStr {
//
//            self.retriveImgFromBucket(key: imgStr) { image in
//                cell.driverprofilepicture.image = image
//            }
//        } else {
//            cell.driverprofilepicture.image = UIImage(named: "profilePlaceHolder")
//        }
        
        if let imgStr = historyDetailList?[indexPath.row].driverDetail?.userProfilePicUrlStr, let url = URL(string: imgStr) {
            cell.driverprofilepicture.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            cell.driverprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            cell.driverprofilepicture.image = UIImage(named: "profilePlaceHolder")
        }
      
        
        if let pickUpLocation = self.historyDetailList?[indexPath.row].pickLocation {
            cell.pickupTxt.text = pickUpLocation
        }
        
        if let serviceType = self.historyDetailList?[indexPath.row].serviceCategory,serviceType == "RENTAL" {
            if let hour = self.historyDetailList?[indexPath.row].rentalPackageHour, let km = self.historyDetailList?[indexPath.row].rentalPackageKm {
                cell.dropTxt.text = "\(hour) hour and \(km) km"
            } else {
                cell.dropTxt.text = serviceType
            }
        } else {
            if let dropLocation = self.historyDetailList?[indexPath.row].dropLocation {
                cell.dropTxt.text = dropLocation
            }
        }
        
        if let serviceType = self.historyDetailList?[indexPath.row].serviceCategory {
            cell.lblRideType.text = serviceType
        }
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        if let date = dateFormatter.date(from: self.historyDetailList?[indexPath.row].tripStartTime ?? "") {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.lblDate.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "hh:mm a"
            cell.lblTime.text = dateFormatter.string(from: date)
        }
        
        
        if self.historySelectionType == .scheduled {
            cell.viewDate.backgroundColor = .themeColor
            cell.viewCancelReason.isHidden = true
            if self.historyDetailList?[indexPath.row].isCompleted ?? false {
                cell.btnCancelScheduleTrip.isHidden = true
                if self.historyDetailList?[indexPath.row].enableDispute ?? false {
                    cell.btnDispute.isHidden = false
                    cell.disputeAction = {[weak self] in
                        self?.moveToDispute(self?.historyDetailList?[indexPath.row].id ?? "")
                    }
                } else {
                    cell.btnDispute.isHidden = true
                }
            } else {
                cell.btnDispute.isHidden = true
                cell.btnCancelScheduleTrip.isHidden = false
                cell.cancelScheduleAction = {[weak self] in
                    self?.rowTobeCancelled = indexPath.row
                    self?.historyView.cancelAlertView.isHidden = false
                    
                }
            }
        } else if self.historySelectionType == .completed {
            cell.btnCancelScheduleTrip.isHidden = true
            cell.viewCancelReason.isHidden = true
            cell.viewDate.backgroundColor = .hexToColor("#48CB90")
            if self.historyDetailList?[indexPath.row].enableDispute ?? false {
                cell.btnDispute.isHidden = false
                cell.disputeAction = {[weak self] in
                    self?.moveToDispute(self?.historyDetailList?[indexPath.row].id ?? "")
                }
            } else {
                cell.btnDispute.isHidden = true
            }
        } else if self.historySelectionType == .cancelled {
            cell.btnCancelScheduleTrip.isHidden = true
            
            cell.viewDate.backgroundColor = .hexToColor("#E76565")
            cell.btnDispute.isHidden = true
            
            if let reason = self.historyDetailList?[indexPath.row].cancelReason {
                cell.viewCancelReason.isHidden = false
                cell.lblCancelReason.text = reason
            } else {
                cell.viewCancelReason.isHidden = true
            }
            if let cancelBy = self.historyDetailList?[indexPath.row].cancelBy {
                cell.lblDate.text = "txt_cancelled_by".localize() + " " + cancelBy
                cell.lblTime.text = ""
            }
            
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.historySelectionType == .completed {
            let vc = Historydetailsvc()
            vc.rideHistory = self.historyDetailList?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func moveToDispute(_ id: String) {
        let complaintsVC = ComplaintVC()
        complaintsVC.historyRequestId = id
        self.navigationController?.pushViewController(complaintsVC, animated: true)
    }
    
    func cancelScheduleTrip(_ id: String) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_cancelling_request".localize())
            var paramDict = Dictionary<String, Any>()
            
            paramDict["request_id"] = id
            paramDict["custom_reason"] = "User Cancelled"
            
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.cancelRide
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            self.navigationController?.popViewController(animated: true)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollValue = scrollView.contentOffset.y
        if scrollValue > (self.historyView.historytbv.contentSize.height - 100 - scrollView.frame.size.height) {
            if self.historySelectionType == .scheduled {
                if (self.scheduledPage ?? 0) < (self.scheduledLastPage ?? 0) && !isLoading {
                    if var page = self.scheduledPage {
                        page += 1
                        self.scheduledPage = page
                        self.gethistorydetails()
                    }
                }
            } else if self.historySelectionType == .completed {
                if (self.completedPage ?? 0) < (self.completedLastPage) ?? 0 && !isLoading {
                    if var page = self.completedPage {
                        
                        page += 1
                        self.completedPage = page
                        self.gethistorydetails()
                    }
                }
            } else if self.historySelectionType == .cancelled {
                if (self.cancelledPage ?? 0) < (self.cancelledLastPage ?? 0) && !isLoading {
                    if var page = self.cancelledPage {
                        page += 1
                        self.cancelledPage = page
                        self.gethistorydetails()
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


