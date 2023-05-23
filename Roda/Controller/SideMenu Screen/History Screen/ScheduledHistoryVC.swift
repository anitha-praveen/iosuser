//
//  ScheduledHistoryVC.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/03/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import GoogleMaps
import Kingfisher

class ScheduledHistoryVC: UIViewController {
    
    private let scheduledHistoryView = ScheduledDetailsView()
    
    private var marker: GMSMarker?
    private var desmarker: GMSMarker?

    var routeStartPoint = CLLocationCoordinate2D()
    var routeEndPoint = CLLocationCoordinate2D()
    
    private var polyline = GMSPolyline()
    private let actualTripPath = GMSMutablePath()
    private var actualTrippolyline:GMSPolyline?
    
    var rideHistory: HistroyDetail?
    var currency = ""
    
    typealias InvoiceContent = (key:String,value:String, textColor:UIColor)
    var invoiceContents = [InvoiceContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduledHistoryView.scrollview.backgroundColor = .clear
                
        setupView()
        setupTarget()
        setupmap()
        setupInvoiceData()
        setupData()
        
    }
    
    func setupView() {
        scheduledHistoryView.setupViews(self.view)
    }
    
    func setupTarget() {
        scheduledHistoryView.mapview.delegate = self
        scheduledHistoryView.listBgView.delegate = self
        scheduledHistoryView.listBgView.dataSource = self
        scheduledHistoryView.listBgView.register(InvoiceCell.self, forCellReuseIdentifier: "InvoiceCell")
        
        scheduledHistoryView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        scheduledHistoryView.cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.scheduledHistoryView.tableHeight?.constant = self.scheduledHistoryView.listBgView.contentSize.height
    }
    
    func setupData() {
        
        if let pickLocation = self.rideHistory?.pickLocation {
            self.scheduledHistoryView.pickupaddrlbl.text = pickLocation
        }
        if let dropLocation = self.rideHistory?.dropLocation {
            self.scheduledHistoryView.dropupaddrlbl.text = dropLocation
        }
        if let time = self.rideHistory?.tripStartTime {
            self.scheduledHistoryView.timeLbl.text = time
        }
    }

}

extension ScheduledHistoryVC {
    func setupInvoiceData() {
        
        if let currency = self.rideHistory?.requestBill?.currency {
            self.currency = currency
        }
        
        if let basePrice = self.rideHistory?.requestBill?.basePrice {
            invoiceContents.append((key:"text_base_price".localize(),
                                    value:currency + " " + basePrice, textColor:UIColor.darkGray))
        }
        
        if let distancePrice = self.rideHistory?.requestBill?.distancePrice {
            invoiceContents.append((key:"text_distance_cost".localize(),
                                    value:currency + " " + distancePrice, textColor:UIColor.darkGray))
        }
        
        if let timePrice = self.rideHistory?.requestBill?.timePrice {
            invoiceContents.append((key:"text_time_cost".localize(),
                                    value:currency + " " + timePrice, textColor:UIColor.darkGray))
        }
        
        if let waitingPrice = self.rideHistory?.requestBill?.waitingPrice {
            invoiceContents.append((key:"waiting_time_price".localize(),
                                    value:currency + " " + waitingPrice, textColor:UIColor.darkGray))
        }
        
        if let promoAmount = self.rideHistory?.requestBill?.promoBonus  {
            invoiceContents.append((key:"text_promo_bonus".localize(),
                                    value: "- \(currency) " + promoAmount, textColor:UIColor.red))
            
        }
       
        self.scheduledHistoryView.listBgView.reloadData()
    }
}
extension ScheduledHistoryVC {

    @objc func backBtnAction(_ sender: UIButton){
        self.rideHistory = nil
        self.marker = nil
        self.desmarker = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelBtnAction() {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_cancelling_request".localize())
            var paramDict = Dictionary<String, Any>()
            
            paramDict["request_id"] = self.rideHistory?.id
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
}

extension ScheduledHistoryVC: GMSMapViewDelegate {
    func setupmap () {
        if let latdouble = self.rideHistory?.pickLatitude, let longdouble = self.rideHistory?.pickLongitude,let destlatdouble = self.rideHistory?.dropLatitude, let destlondouble = self.rideHistory?.dropLongitude  {
            
            marker?.position = CLLocationCoordinate2D(latitude: latdouble, longitude: longdouble)
            marker?.icon = UIImage(named:"ic_pick_pin")
            marker?.map = scheduledHistoryView.mapview
            
            desmarker?.position = CLLocationCoordinate2D(latitude: destlatdouble, longitude: destlondouble)
            desmarker?.icon = UIImage(named:"ic_destination_pin")
            desmarker?.map = scheduledHistoryView.mapview
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: latdouble, longitude: longdouble), coordinate: CLLocationCoordinate2D(latitude: destlatdouble, longitude: destlondouble))
            self.scheduledHistoryView.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
            
            routeStartPoint = CLLocationCoordinate2D(latitude: latdouble, longitude: longdouble)
            routeEndPoint = CLLocationCoordinate2D(latitude: destlatdouble, longitude: destlondouble)
            
            
            
            if rideHistory?.isCompleted == true {
                scheduledHistoryView.cancelBtn.isHidden = true
                scheduledHistoryView.distanceLbl.isHidden = true
                scheduledHistoryView.distanceTitleLbl.isHidden = true
                scheduledHistoryView.durationLbl.isHidden = true
                scheduledHistoryView.durationTitleLbl.isHidden = true
                scheduledHistoryView.listBgView.isHidden = false
                scheduledHistoryView.billdetailslbl.isHidden = false
            } else {
                if rideHistory?.isCancelled == true {
                    scheduledHistoryView.cancelBtn.isHidden = true
                } else {
                    scheduledHistoryView.cancelBtn.isHidden = false
                }
                scheduledHistoryView.distanceLbl.isHidden = false
                scheduledHistoryView.distanceTitleLbl.isHidden = false
                scheduledHistoryView.durationLbl.isHidden = false
                scheduledHistoryView.durationTitleLbl.isHidden = false
                scheduledHistoryView.listBgView.isHidden = true
                scheduledHistoryView.billdetailslbl.isHidden = true
            }
            self.fetchMapData()
            
        }
    }
    
//  To draw a polyline on mapview
    func fetchMapData() {
        
        let queryItems = [URLQueryItem(name: "origin", value: "\(routeStartPoint.latitude),\(routeStartPoint.longitude)"),URLQueryItem(name: "destination", value: "\(routeEndPoint.latitude),\(routeEndPoint.longitude)"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: "\(APIHelper.shared.gmsDirectionKey)")]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)
        
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                print("DATA FROM MAP", response.result.value as Any)
                if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String, let legs = route["legs"] as? [[String:AnyObject]], let legFirst = legs.first, let data = legFirst["distance"] as? [String: AnyObject],let timeData = legFirst["duration"] as? [String:Any] {
                    let line  = points
                    self.addPolyLine(encodedString: line)
                    if let distance = data["text"] as? String {
                        self.scheduledHistoryView.distanceLbl.text = distance
                    }
                    if let duration = timeData["text"] as? String {
                        self.scheduledHistoryView.durationLbl.text = duration
                    }

                }
                
            }
            
        }
    }
    
    func addPolyLine(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4
        polyline.strokeColor = .txtColor
        polyline.map = scheduledHistoryView.mapview
       
    }
}


extension ScheduledHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceContents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as? InvoiceCell ?? InvoiceCell()
        
        cell.selectionStyle = .none

        cell.keyLbl.text = invoiceContents[indexPath.row].key
        cell.valueLbl.text = invoiceContents[indexPath.row].value
        cell.keyLbl.textColor = invoiceContents[indexPath.row].textColor
        cell.valueLbl.textColor = invoiceContents[indexPath.row].textColor
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 61
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        footer.backgroundColor = .clear
        
        var layoutDict = [String: AnyObject]()
        
        let invoiceLineView2 = UIView()
        invoiceLineView2.backgroundColor = .gray
        invoiceLineView2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceLineView2"] = invoiceLineView2
        footer.addSubview(invoiceLineView2)
        
        let bgView = UIView()
        bgView.backgroundColor = .secondaryColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["bgView"] = bgView
        footer.addSubview(bgView)
        
        let totheaderlbl = UILabel()
        totheaderlbl.text = "txt_Total".localize()
        totheaderlbl.textAlignment = APIHelper.appTextAlignment
        totheaderlbl.font = UIFont.appSemiBold(ofSize: 20)
        totheaderlbl.textColor = .txtColor
        totheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totheaderlbl"] = totheaderlbl
        bgView.addSubview(totheaderlbl)
        
        let totLbl = UILabel()
        if let totalStr = self.rideHistory?.requestBill?.totalAmount {
            
            totLbl.text = self.currency + " " + totalStr
        }
        totLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        totLbl.font = UIFont.appSemiBold(ofSize: 20)
        totLbl.textColor = .txtColor
        totLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totLbl"] = totLbl
        bgView.addSubview(totLbl)
        
        let cuttedlineIv = UIImageView()
        cuttedlineIv.image = UIImage(named:"Zig_zag")
        cuttedlineIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cuttedlineIv"] = cuttedlineIv
        footer.addSubview(cuttedlineIv)
        
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[invoiceLineView2(1)]-(0)-[bgView(50)]-(0)-[cuttedlineIv(10)]|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceLineView2]-(15)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bgView]-(0)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[totheaderlbl(25)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[totheaderlbl]-(10)-[totLbl]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        totheaderlbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}
