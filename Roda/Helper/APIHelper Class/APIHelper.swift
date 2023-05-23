//
//  APIHelper.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import NVActivityIndicatorView
protocol LogoutDelegate {
    func logout()
}
class APIHelper: NSObject {
    
    static let shared = APIHelper()
    
    var userDetails: UserDetails?
    
    
    var delegate: LogoutDelegate?
    
    let activityData = ActivityData(type: .ballClipRotate, color: .themeColor)
    let activityPulseData = ActivityData(type: .ballClipRotatePulse, color: .themeColor)
    
    
    static var userInterfaceDirection: UIUserInterfaceLayoutDirection {
        return currentAppLanguage == "ar" ? .rightToLeft : .leftToRight
    }
    
    static var appLanguageDirection: NSLayoutConstraint.FormatOptions {
        return currentAppLanguage == "ar" ? .directionRightToLeft : .directionLeftToRight
    }
    static var appTextAlignment: NSTextAlignment {
        return currentAppLanguage == "ar" ? .right : .left
    }
    static var appSemanticContentAttribute: UISemanticContentAttribute {
        return currentAppLanguage == "ar" ? .forceRightToLeft : .forceLeftToRight
    }
    
    static var currentAppLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "currentLanguage") ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentLanguage")
            UserDefaults.standard.synchronize()
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
        }
    }
   
    static var firebaseVerificationCode: String {
        get {
            return UserDefaults.standard.string(forKey: "VerificationCode") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "VerificationCode")
            UserDefaults.standard.synchronize()
        }
    }
    

    var landingPage: String {
        get {
            return UserDefaults.standard.string(forKey: "LandingPage") ?? "Get Started"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LandingPage")
        }
    }
    
    
    var currentLangDate: Double {
        get {
            return UserDefaults.standard.double(forKey: "CurrentLangDate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CurrentLangDate")
        }
    }
    
    var isTourGuideShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: "showCase")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showCase")
        }
    }
    
    static var pathToPickup: String {
        get {
            return UserDefaults.standard.string(forKey: "pathToPickup") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pathToPickup")
            UserDefaults.standard.synchronize()
        }
    }
    
    var deviceToken = "Default Token"
    var appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
    
    
    let autoCompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    
//    let BASEURL = "http://54.243.199.208/taxi/public/api/"
//    let BASEURL = "https://www.rodacabs.com/taxi/public/api/"
    #if DEBUG
    let BASEURL = "http://3.216.234.12/roda/public/api/"
    static let socketUrl = URL(string: "http://3.216.234.12:3001")!
    static let appBaseCode = "V-53f3ee0ba2223997e7a7f85601b416f7"
    
    var gmsServiceKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    var gmsPlacesKey  = "AIzaSyBa6bO_40mnI3QIttrKQmKB9GErFDWDiK4"
    var gmsDirectionKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    #else
    let BASEURL = "http://3.216.234.12/roda/public/api/"
    static let socketUrl = URL(string: "http://3.216.234.12:3001")!
    static let appBaseCode = "V-53f3ee0ba2223997e7a7f85601b416f7"
    
    var gmsServiceKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    var gmsPlacesKey  = "AIzaSyA0Iv-Af7Vu3qmiVxo_nuCKW-c2Z2t-1Dk"
    var gmsDirectionKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    #endif
    
    
    var header: [String: String] {
        return ["Accept": "application/json", "Content-Language": "en"]
    }
    var authHeader: [String: String] {
        return ["Authorization": APIHelper.shared.userDetails?.accessToken ?? "", "Content-Language": "en","Accept": "application/json"]
    }
    
    // -----------------------
    
    static let getAppCountryLangData                   = "V1/languages"
    static let sendOTP                                 = "V1/user/sendotp"
    static let loginUser                               = "V1/user/signin"
    static let signupUser                              = "V1/user/signup"
    static let authToken                               = "V1/auth/token"
    static let getUserProfile                          = "V1/user/profile"
    static let getVerifyUser                           = "V1/user/check/phonenumber"
    static let getSOSList                              = "V1/sos"
    static let deleteSOS                               = "V1/sos/delete/"
    static let addSOSNumber                            = "V1/sos/store"
    static let getComplaintList                        = "V1/complaints/list"
    static let getComplaintAdd                         = "V1/complaints/add"
    static let getSuggestionList                       = "V1/suggestions/list"
    static let getFAQList                              = "V1/faq"
    static let getFaourite                             = "V1/favourite"
    static let deleteFavourite                         = "V1/favourite/delete"
    static let getTypes                                = "V1/get/types"
    static let checkRequestinProgress                  = "V1/user/request_in_progress"
    static let getPromoList                            = "V1/user/promocode"
    static let applyPromoCode                          = "V1/user/promoapply"
    static let createRequest                           = "V1/request/create"
    static let rideLaterRequest                        = "V1/request/ride-later"
    static let getHistoryList                          = "V1/request/user/trip/history"
    static let cancelRide                              = "V1/request/cancel/user"
    static let getCancellationReason                   = "V1/cancellation/list"
    static let rateDriver                              = "V1/request/rating"
    static let cancelTrip                              = "V1/request/cancel/user"
    static let logoutUser                              = "V1/user/logout"
    static let getWalletAmount                         = "V1/wallet"
    static let addWalletAmount                         = "V1/wallet/add-amount"
    static let changeTripLocation                      = "V1/request/change-location"
    static let getTripComplaintList                    = "V1/complaints/trip-list"
    static let getNotificationList                     = "V1/notification/list"
    static let updateAppLanguage                       = "V1/user/profile/language"
    static let checkUserZone                           = "V1/checkzone"
    static let getOutStationList                       = "V1/outstation/list"
    static let getOutStationTypes                      = "V1/outstation/eta"
    static let getReferralDetails                      = "V1/get/user/referral"
    static let getAdminContact                         = "V1/customer-care"
    static let getPackageList                          = "V1/rental/list"
    static let getPackageTypes                         = "V1/rental/eta"
    static let checkOutstationZone                     = "V1/check/outstation"
    static let skipNytTimePhoto                        = "V1/request/skip-upload"
    static let uploadNytTimePhoto                      = "V1/request/image-upload"
    static let retakeDriverPhoto                       = "V1/request/retake-image"
    static let getFeedbackQuestions                    = "V1/invoice/question"
    static let deleteAccount                           = "V1/userdelete/delete"
    static let createOrderID                           = "V1/create/order"
    static let updatePaymentStatus                     = "V1/update/payment/status"
    static let changePaymentMode                       = "V1/change/payment"

    static var googleApiComponents = URLComponents()
   
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "UserDetails")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
}


// MARK: - Core Data Saving support
extension APIHelper {
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchUsers() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let users = try persistentContainer.viewContext.fetch(fetchRequest)
            if users.count == 1 {
                self.userDetails = UserDetails(users.first!)
                
            } else {
                print("0 or more than one object found")
            }
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
    func deleteUser() {
        do {
            let context = APIHelper.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Userdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                self.userDetails = nil
                MySocketManager.shared.socket.disconnect()
                AppLocationManager.shared.stopTracking()
                delegate?.logout()
                UserDefaults.standard.removeObject(forKey: "currentLanguage")
                RJKLocalize.shared.details = [:]
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
        
    }
    
    func updateUserDetails(_ userDetails:[String:AnyObject])
    {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do
        {
            let users = try self.persistentContainer.viewContext.fetch(fetchRequest)
            if users.count == 1, let user = users.first
            {
                self.storeUserDetails(userDetails, currentUser: user)
            }
            else
            {
                print("No users found or multiple user details found")
            }
        }
        catch let error
        {
            print("ERROR  : \(error)")
        }
    }
    
    func storeUserDetails(_ userDetailsDic: [String:AnyObject], currentUser:Userdetails?) {
        
        let context = APIHelper.shared.persistentContainer.viewContext
        let userObj = currentUser ?? Userdetails(context: context)
        
        print("userDictionary is: ",userDetailsDic)
        
        if let email = userDetailsDic["email"] as? String {
            userObj.email = email
        }
        if let firstName = userDetailsDic["firstname"] as? String {
            userObj.firstname = firstName
        }
        if let id = userDetailsDic["slug"] as? String {
            userObj.id = id
        }
        if let lastName = userDetailsDic["lastname"] as? String {
            userObj.lastname = lastName
        }
        
        if let phone = userDetailsDic["phone_number"] as? String {
            userObj.phone = phone
        }
        if let profilePictureUrl = userDetailsDic["profile_pic"] as? String {
            userObj.profilepictureurl = profilePictureUrl
        }
        if let token = userDetailsDic["token"] as? String {
            userObj.token = token
        }
        if let accessToken = userDetailsDic["access_token"] as? String {
            userObj.accessToken = accessToken
        }
        
        do {
            try context.save()
            print("saved!")
            self.fetchUsers()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
}

//MARK:- Model classes to store core data objects in local
struct UserDetails {
    
    var email: String?
    var firstName: String?
    var id: String?
    var lastName: String?
    var phone: String?
    var profilePictureUrl: String?
    var token: String?
    var accessToken: String?
   
    init(_ object: Userdetails) {
        self.email = object.value(forKey: "email") as? String
        self.firstName = object.value(forKey: "firstname") as? String
        self.id = object.value(forKey: "id") as? String
        self.lastName = object.value(forKey: "lastname") as? String
        self.phone = object.value(forKey: "phone") as? String
        self.profilePictureUrl = object.value(forKey: "profilepictureurl") as? String
        self.token = object.value(forKey: "token") as? String
        self.accessToken = object.value(forKey: "accessToken") as? String
    }
}
