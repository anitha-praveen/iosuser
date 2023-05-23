//
//  OnboardScreenVC.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//


import UIKit

class OnboardScreenVC: UIViewController {
    
    let viewContent = UIView()
    let imgView = UIImageView()
    let lblHint = UILabel()
    let lblDescription = UILabel()
    var pageIndex = 0
    var layoutDict = [String: AnyObject]()
    
    init(_ img:String, hint: String, desc: String ,pageIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.pageIndex = pageIndex
        setupViews(img, hint: hint, desc: desc)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupViews(_ img: String, hint: String, desc: String) {
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewContent)
        
        imgView.image = UIImage(named: img)
        imgView.contentMode = .scaleAspectFit
        layoutDict["imgView"] = imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(imgView)
        
        lblHint.text = hint
        lblHint.textAlignment = .center
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .txtColor
        lblHint.font = UIFont.appBoldFont(ofSize: 26)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(lblHint)
        
        lblDescription.text = desc
        lblDescription.textAlignment = .center
        lblDescription.textColor = .txtColor
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(lblDescription)
        
        viewContent.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        viewContent.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblHint]-32-|", options: [], metrics: nil, views: layoutDict))
         self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblDescription]-32-|", options: [], metrics: nil, views: layoutDict))
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[imgView]-10-[lblHint]-10-[lblDescription]-30-|", options: [], metrics: nil, views: layoutDict))
        
    }

}

class OnBoardCurvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.applyCurvedPath(givenView: self, curvedPercent: 0.5)
    }
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:0, y:givenView.bounds.size.height-30))
        
        arrowPath.addQuadCurve(to: CGPoint(x:50, y:givenView.bounds.size.height), controlPoint: CGPoint(x:0, y:givenView.bounds.size.height))
        
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width-50, y:givenView.bounds.size.height))
        
        arrowPath.addQuadCurve(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height-30), controlPoint: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height))
        
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.close()
        UIColor.themeColor.setFill()
        arrowPath.fill()
        return arrowPath
    }
    
    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
}

