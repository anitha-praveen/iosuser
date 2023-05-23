//
//  TaxiPickupView.swift
//  Taxiappz
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import SWRevealViewController
import Kingfisher
import MarqueeLabel


class TaxiPickupView: UIView {
    
    let btnMenu = UIButton()
    
    let btnNotification = UIButton()
    
    var mapview = GMSMapView()
    let pickMarkerView = PickupMarkerView()
    
    let stackDestination = UIStackView()
    
    let viewSearchDestination = UIView()
    let lblChooseDestination = UILabel()
    let imgSearch = UIImageView()
    let btnFav = UIButton()
    
    let tblRecentLocation = UITableView()
    var recentTableHeightConstraint: NSLayoutConstraint?
    
    let viewRideCategory = UIView()
    let collectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let stackPackage = UIStackView()
    let viewPackageList = UIView()
    let lblSelectPackage = UILabel()
    let packageCollectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let btnCurrentLocation = UIButton()
    
    let blurView = UIView()
    let serviceUnavailableView = UIView()
    let serviceUnavailableLbl = UILabel()
    let stayTunedLbl = UILabel()
    let serviceUnavailableImgView = UIImageView()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {

        baseView.subviews.forEach({
            $0.removeAllConstraints()
            $0.removeFromSuperview()
        })
        baseView.backgroundColor = UIColor.secondaryColor
        
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }

        mapview.isMyLocationEnabled = true
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        pickMarkerView.isUserInteractionEnabled = true
        layoutDict["pickMarkerView"] = pickMarkerView
        pickMarkerView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(pickMarkerView)
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            btnMenu.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        } else {
            btnMenu.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)

        }
        btnMenu.layer.cornerRadius = 25
        btnMenu.clipsToBounds = true
        btnMenu.setImage(UIImage(named: "ic_menu"), for: .normal)
        layoutDict["btnMenu"] = btnMenu
        btnMenu.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnMenu)
        
        
        btnNotification.layer.cornerRadius = 20
        btnNotification.clipsToBounds = true
        btnNotification.setImage(UIImage(named: "ic_notification_bell"), for: .normal)
        layoutDict["btnNotification"] = btnNotification
        btnNotification.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnNotification)
        
        stackDestination.axis = .vertical
        stackDestination.distribution = .fill
        layoutDict["stackDestination"] = stackDestination
        stackDestination.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(stackDestination)
        
        viewSearchDestination.layer.cornerRadius = 10
        viewSearchDestination.backgroundColor = .secondThemeColor
        layoutDict["viewSearchDestination"] = viewSearchDestination
        viewSearchDestination.translatesAutoresizingMaskIntoConstraints = false
        stackDestination.addArrangedSubview(viewSearchDestination)
        
        imgSearch.contentMode = .scaleAspectFit
        imgSearch.tintColor = .secondaryColor
        imgSearch.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        layoutDict["imgSearch"] = imgSearch
        imgSearch.translatesAutoresizingMaskIntoConstraints = false
        viewSearchDestination.addSubview(imgSearch)
        
        
       
        lblChooseDestination.isUserInteractionEnabled = false
        lblChooseDestination.textAlignment = APIHelper.appTextAlignment
        lblChooseDestination.textColor = .secondaryColor
        lblChooseDestination.font = UIFont.appRegularFont(ofSize: 16)
        lblChooseDestination.text = "txt_where_going".localize()
        layoutDict["lblChooseDestination"] = lblChooseDestination
        lblChooseDestination.translatesAutoresizingMaskIntoConstraints = false
        viewSearchDestination.addSubview(lblChooseDestination)
        
        btnFav.isHidden = true
        btnFav.imageView?.tintColor = .secondaryColor
        btnFav.setImage(UIImage(named: "ic_unfav")?.withRenderingMode(.alwaysTemplate), for: .normal)
        layoutDict["btnFav"] = btnFav
        btnFav.translatesAutoresizingMaskIntoConstraints = false
        viewSearchDestination.addSubview(btnFav)
        
        tblRecentLocation.alwaysBounceVertical = false
        tblRecentLocation.backgroundColor = .secondaryColor
        layoutDict["tblRecentLocation"] = tblRecentLocation
        tblRecentLocation.translatesAutoresizingMaskIntoConstraints = false
        stackDestination.addArrangedSubview(tblRecentLocation)
        
        viewRideCategory.layer.cornerRadius = 30
        viewRideCategory.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewRideCategory.clipsToBounds = true
        viewRideCategory.backgroundColor = .secondaryColor
        layoutDict["viewRideCategory"] = viewRideCategory
        viewRideCategory.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewRideCategory)
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 0
        collectionvw.collectionViewLayout = collectionLayout
        collectionvw.alwaysBounceHorizontal = false
        collectionvw.backgroundColor = .secondaryColor
        collectionvw.showsHorizontalScrollIndicator = false
        layoutDict["collectionvw"] = collectionvw
        collectionvw.translatesAutoresizingMaskIntoConstraints = false
        viewRideCategory.addSubview(collectionvw)
        
        stackPackage.axis = .vertical
        stackPackage.distribution = .fill
        layoutDict["stackPackage"] = stackPackage
        stackPackage.translatesAutoresizingMaskIntoConstraints = false
        viewRideCategory.addSubview(stackPackage)
        
        viewPackageList.isHidden = true
        layoutDict["viewPackageList"] = viewPackageList
        viewPackageList.translatesAutoresizingMaskIntoConstraints = false
        stackPackage.addArrangedSubview(viewPackageList)
        
        lblSelectPackage.text = "txt_select_package".localize()
        lblSelectPackage.textAlignment = APIHelper.appTextAlignment
        lblSelectPackage.font = UIFont.appBoldFont(ofSize: 16)
        lblSelectPackage.textColor = .txtColor
        layoutDict["lblSelectPackage"] = lblSelectPackage
        lblSelectPackage.translatesAutoresizingMaskIntoConstraints = false
        viewPackageList.addSubview(lblSelectPackage)
        
        let packageLayout = UICollectionViewFlowLayout()
        packageLayout.scrollDirection = .horizontal
        packageLayout.minimumInteritemSpacing = 0
        packageCollectionvw.collectionViewLayout = packageLayout
        packageCollectionvw.alwaysBounceHorizontal = false
        packageCollectionvw.backgroundColor = .secondaryColor
        packageCollectionvw.showsHorizontalScrollIndicator = false
        layoutDict["packageCollectionvw"] = packageCollectionvw
        packageCollectionvw.translatesAutoresizingMaskIntoConstraints = false
        viewPackageList.addSubview(packageCollectionvw)
        
        
        btnCurrentLocation.setImage(UIImage(named: "current_location"), for: .normal)
        //btnCurrentLocation.contentMode = .scaleAspectFit
        layoutDict["btnCurrentLocation"] = btnCurrentLocation
        btnCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnCurrentLocation)
        
        
        // --------------------Non service zone
        blurView.isHidden = true
        blurView.backgroundColor = .clear
        layoutDict["blurView"] = blurView
        blurView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(blurView)
        baseView.bringSubviewToFront(btnMenu)
        
        serviceUnavailableView.layer.cornerRadius = 10
        serviceUnavailableView.layer.shadowColor = UIColor.lightGray.cgColor
        serviceUnavailableView.layer.shadowOpacity = 1
        serviceUnavailableView.layer.shadowOffset = CGSize(width: -1, height: 1)
        serviceUnavailableView.layer.shadowRadius = 5

        serviceUnavailableView.backgroundColor = .secondaryColor
        layoutDict["serviceUnavailableView"] = serviceUnavailableView
        serviceUnavailableView.translatesAutoresizingMaskIntoConstraints = false
        blurView.addSubview(serviceUnavailableView)
        
        serviceUnavailableLbl.text = "txt_service_unavailable_title".localize()
        serviceUnavailableLbl.textAlignment = .left
        serviceUnavailableLbl.textColor = .txtColor
        serviceUnavailableLbl.font = UIFont.boldSystemFont(ofSize: 24)
        serviceUnavailableLbl.numberOfLines = 0
        serviceUnavailableLbl.lineBreakMode = .byWordWrapping
        layoutDict["serviceUnavailableLbl"] = serviceUnavailableLbl
        serviceUnavailableLbl.translatesAutoresizingMaskIntoConstraints = false
        serviceUnavailableView.addSubview(serviceUnavailableLbl)
        
        stayTunedLbl.text = "text_stayTuned".localize()
        stayTunedLbl.textAlignment = .left
        stayTunedLbl.textColor = .lightGray
        stayTunedLbl.font = UIFont.appSemiBold(ofSize: 17)
        stayTunedLbl.numberOfLines = 0
        stayTunedLbl.lineBreakMode = .byWordWrapping
        layoutDict["stayTunedLbl"] = stayTunedLbl
        stayTunedLbl.translatesAutoresizingMaskIntoConstraints = false
        serviceUnavailableView.addSubview(stayTunedLbl)
        
        serviceUnavailableImgView.image = UIImage(named: "nonServiceZone")
        serviceUnavailableImgView.contentMode = .scaleAspectFit
        layoutDict["serviceUnavailableImgView"] = serviceUnavailableImgView
        serviceUnavailableImgView.translatesAutoresizingMaskIntoConstraints = false
        serviceUnavailableView.addSubview(serviceUnavailableImgView)
        
        
        setupConstraints(Base: baseView)
        
    }
    
    func setupConstraints(Base baseView: UIView) {

        self.setupData()
        btnMenu.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        btnMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnMenu(50)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        btnNotification.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnNotification.centerYAnchor.constraint(equalTo: btnMenu.centerYAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnNotification(50)]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: viewRideCategory.topAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        pickMarkerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pickMarkerView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        pickMarkerView.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        pickMarkerView.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: -10).isActive = true
       
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnCurrentLocation(50)]-10-|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnCurrentLocation(50)]-10-[stackDestination]-10-[viewRideCategory]", options: [], metrics: nil, views: layoutDict))
        
      
        viewRideCategory.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewRideCategory]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewRideCategory.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionvw(90)]-5-[stackPackage]|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackPackage]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewPackageList.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblSelectPackage(30)]-5-[packageCollectionvw(50)]-12-|", options: [], metrics: nil, views: layoutDict))
        viewPackageList.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblSelectPackage]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewPackageList.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[packageCollectionvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackDestination]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewSearchDestination.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblChooseDestination(35)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewSearchDestination.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[imgSearch(20)]-15-[lblChooseDestination]-16-[btnFav(20)]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgSearch.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgSearch.centerYAnchor.constraint(equalTo: lblChooseDestination.centerYAnchor, constant: 0).isActive = true
        btnFav.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnFav.centerYAnchor.constraint(equalTo: lblChooseDestination.centerYAnchor, constant: 0).isActive = true
        
        self.recentTableHeightConstraint = tblRecentLocation.heightAnchor.constraint(equalToConstant: 0)
        self.recentTableHeightConstraint?.isActive = true
        
        
        // -------No service View
        blurView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurView]|", options: [], metrics: nil, views: layoutDict))
        

        blurView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[serviceUnavailableView]-1-|", options: [], metrics: nil, views: layoutDict))
        blurView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[serviceUnavailableView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        serviceUnavailableImgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        serviceUnavailableImgView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        serviceUnavailableImgView.centerYAnchor.constraint(equalTo: serviceUnavailableView.centerYAnchor).isActive = true
        
        serviceUnavailableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[serviceUnavailableLbl]-15-[serviceUnavailableImgView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        

        serviceUnavailableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[serviceUnavailableLbl]-17-[stayTunedLbl]-40-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
     
    }
    
    func setupData() {
        pickMarkerView.lblPickupAt.text = "txt_pickup_at".localize().uppercased()
        pickMarkerView.lblPickupAt.textAlignment = APIHelper.appTextAlignment
        pickMarkerView.lblPickupAddress.textAlignment = APIHelper.appTextAlignment
    }
}
extension UIView {
    func removeAllConstraint() {
        self.removeConstraints(self.constraints)
        self.subviews.forEach { $0.removeAllConstraint() }
    }
}


