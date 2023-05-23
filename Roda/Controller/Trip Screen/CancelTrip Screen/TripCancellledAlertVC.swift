//
//  TripCancellledAlertVC.swift
//  Petra Ride
//
//  Created by NPlus Technologies on 03/09/19.
//  Copyright © 2019 Mohammed Arshad. All rights reserved.
//

import UIKit
import AVKit
class TripCancellledAlertVC: UIViewController {
    
    var player:AVAudioPlayer?
    var callBack:((String)->Void)?
    var fileName: String?
    let lbl = UILabel()
    let imgView = UIImageView()
    let okBtn = UIButton(type: .custom)
    let cancelBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

       setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playSound()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopSound()
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToForeground(_ notification: Notification) {
        playSound()
    }
   
    
    func setupViews() {
        view.backgroundColor = .secondaryColor
        
        let contentView = UIView()
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        lbl.font = UIFont.appBoldTitleFont(ofSize: 24)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.textColor = .themeColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lbl)
        
        
        imgView.contentMode = .scaleAspectFit
      
        imgView.image = UIImage(named: "tripcancelledAlert")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
        
        
        okBtn.addTarget(self, action: #selector(okBtnAction(_:)), for: .touchUpInside)
        okBtn.setTitleColor(.secondaryColor, for: .normal)
       
            okBtn.setTitle("text_goHome".localize(), for: .normal)
       
        
        okBtn.backgroundColor = .themeColor
        okBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okBtn)
        
        
      //  cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        cancelBtn.setTitleColor(.secondaryColor, for: .normal)
        cancelBtn.setTitle("text_no".localize(), for: .normal)
        cancelBtn.backgroundColor = .themeColor
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelBtn)
       
        cancelBtn.isHidden = true
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[contentView]-(20)-|", options: [], metrics: nil, views: ["contentView":contentView]))
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lbl]-(10)-|", options: [], metrics: nil, views: ["lbl":lbl]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[lbl(>=50)]-(30)-[imgView(230)]-30-[okBtn(40)]-(10)-|", options: [], metrics: nil, views: ["lbl":lbl,"okBtn":okBtn,"imgView":imgView]))
        imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
       
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[okBtn]-(10)-|", options: [], metrics: nil, views: ["okBtn":okBtn]))
        
    }
    
    @objc func okBtnAction(_ sender: UIButton) {
        callBack?("")
        self.dismiss(animated: true, completion: nil)
    }
    
    func playSound() {
        self.player?.stop()
        self.player = nil
        if let fileName = self.fileName, let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let url = URL(fileURLWithPath:path)
            if let player = try? AVAudioPlayer(contentsOf: url) {
                self.player = player
                self.player?.numberOfLoops = -1
                self.player?.prepareToPlay()
                self.player?.play()
            }
        }
    }
    
    func stopSound() {
        self.player?.stop()
        self.player = nil
    }
}
