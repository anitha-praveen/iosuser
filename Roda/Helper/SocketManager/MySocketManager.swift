//
//  MySocketManager.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import Foundation
import UIKit
import SocketIO

@objc protocol MySocketManagerDelegate: AnyObject {

    @objc optional func tripStatusResponseReceived(_ response: [String: AnyObject])
    @objc optional func rideLocationChanged(_ response:[String:AnyObject])
    @objc optional func serviceCategoryChanged(_ response:[String:AnyObject])
    @objc optional func uploaduserPhoto(_ response: [String:AnyObject])
    @objc optional func nytTimePhotoSkipped(_ response: [String:AnyObject])
    @objc optional func paymentProcessed(_ response: [String:AnyObject])
    
}

class MySocketManager: NSObject {

    static let shared = MySocketManager()
    weak var socketDelegate: MySocketManagerDelegate?
    let manager = SocketManager(socketURL: APIHelper.socketUrl, config: [.reconnects(true), .reconnectAttempts(-1)])
    var socket: SocketIOClient!
    
    private override init() {
        super.init()
        socket = manager.defaultSocket
        self.updateStatus()
    }
    
    func updateStatus() {
        
        if socket != nil {
            socket.on(clientEvent: .statusChange) { (dataArr, _) in
                guard let status = dataArr.first as? SocketIOStatus else {
                    return
                }
                switch status {
                case .connected:
                    print("socket started")
                case .notConnected:
                    print("socket not connected")
                   // self.manager.reconnect()
                case .connecting:
                    print("socket connecting")
                case .disconnected:
                    print("socket disconnected")
                }
            }
        }
    }
    
    func establishConnection() {
        print("trying to connect socket")
        self.socket.on("connect") { data, _ in
            print("socket connected")
            MySocketManager.shared.addObservers()
           
        }
        self.socket.connect()
    }
   
}
extension MySocketManager {
    func addObservers() {
        
        guard let userID = APIHelper.shared.userDetails?.id else {
            return
        }
        print("socket observer",userID)
        
        socket.on("request_\(userID)") { data, _ in
            print("//----------Socket Request response")
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            print("Socket request",response)
            //-----------
            DispatchQueue.main.async {
                self.socketDelegate?.tripStatusResponseReceived?(response)
            }
        }
        self.socket.on("locationchanged_\(userID)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.rideLocationChanged?(response)
            }
        }
        self.socket.on("package_changed_\(userID)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.serviceCategoryChanged?(response)
            }
        }
        self.socket.on("photo_upload_\(userID)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main
                .async {
                    self.socketDelegate?.uploaduserPhoto?(response)
                }
        }
        self.socket.on("skip_photo_upload_\(userID)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main
                .async {
                    self.socketDelegate?.nytTimePhotoSkipped?(response)
                }
        }
        self.socket.on("payment_done_\(userID)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main
                .async {
                    self.socketDelegate?.paymentProcessed?(response)
                }
        }
        
        
    }
}

