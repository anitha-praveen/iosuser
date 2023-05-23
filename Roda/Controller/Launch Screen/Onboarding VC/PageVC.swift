//
//  PageVC.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit

class PageVC: UIPageViewController {
    /*
    OnboardScreenVC("img_onboard_one", hint: "txt_live_tracking".localize(), desc: "txt_live_desc".localize() , pageIndex: 2),
    OnboardScreenVC("img_onboard_two", hint: "txt_trip_share".localize(), desc: "txt_trip_desc".localize() ,pageIndex: 3)
     */
    let pages:[UIViewController] = [OnboardScreenVC("img_onboard_one", hint: "txt_req_ride".localize(), desc:       "txt_req_desc".localize() , pageIndex: 0),
                                    OnboardScreenVC("img_onboard_two", hint: "txt_live_tracking".localize(), desc: "txt_live_desc".localize() , pageIndex: 1)]
    
    let viewPageIndicator = UIStackView()
    let firstPageIndicator = UIView()
    let secondPageIndicator = UIView()
    
    var firstPageWidth: NSLayoutConstraint?
    var secondPageWidth: NSLayoutConstraint?
    
    let btnNext = UIButton()
    
    var currentIndex = 0
    
    var layoutDict = [String: AnyObject]()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .secondaryColor
        self.delegate = self
        self.dataSource = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        let viewPageController = UIView()
        layoutDict["viewPageController"] = viewPageController
        viewPageController.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewPageController)
        
        viewPageIndicator.axis = .horizontal
        viewPageIndicator.distribution = .fill
        viewPageIndicator.spacing = 5
        layoutDict["viewPageIndicator"] = viewPageIndicator
        viewPageIndicator.translatesAutoresizingMaskIntoConstraints = false
        viewPageController.addSubview(viewPageIndicator)
        

        
        firstPageIndicator.backgroundColor = .themeColor
        firstPageIndicator.layer.cornerRadius = 5
        layoutDict["firstPageIndicator"] = firstPageIndicator
        firstPageIndicator.translatesAutoresizingMaskIntoConstraints = false
        viewPageIndicator.addArrangedSubview(firstPageIndicator)
        
        secondPageIndicator.backgroundColor = .txtColor
        secondPageIndicator.layer.cornerRadius = 5
        layoutDict["secondPageIndicator"] = secondPageIndicator
        secondPageIndicator.translatesAutoresizingMaskIntoConstraints = false
        viewPageIndicator.addArrangedSubview(secondPageIndicator)
        
        btnNext.layer.cornerRadius = 8
        btnNext.imageView?.contentMode = .center
        btnNext.imageView?.tintColor = .secondaryColor
        btnNext.setImage(UIImage(named: "rightSideArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnNext.addTarget(self, action: #selector(btnNextPressed(_ :)), for: .touchUpInside)
        btnNext.backgroundColor = .themeColor
        layoutDict["btnNext"] = btnNext
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        viewPageController.addSubview(btnNext)
        
        
        viewPageController.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        viewPageController.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewPageController]|", options: [], metrics: nil, views: layoutDict))
        

        viewPageController.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnNext(40)]-15-|", options: [], metrics: nil, views: layoutDict))
        viewPageController.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnNext(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
       
        viewPageIndicator.centerYAnchor.constraint(equalTo: btnNext.centerYAnchor, constant: 0).isActive = true
        viewPageController.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPageIndicator]", options: [], metrics: nil, views: layoutDict))
        
        firstPageIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        secondPageIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.firstPageWidth = firstPageIndicator.widthAnchor.constraint(equalToConstant: 50)
        self.secondPageWidth = secondPageIndicator.widthAnchor.constraint(equalToConstant: 10)
        
        self.firstPageWidth?.isActive = true
        self.secondPageWidth?.isActive = true
        
    }
    
    func changePageIndicator() {
        [self.firstPageWidth,self.secondPageWidth].enumerated().forEach{
            if $0 == self.currentIndex {
                $1?.constant = 50
            } else {
                $1?.constant = 10
            }
        }
        [self.firstPageIndicator,self.secondPageIndicator].enumerated().forEach{
            if $0 == self.currentIndex {
                $1.backgroundColor = .themeColor
            } else {
                $1.backgroundColor = .txtColor
            }
        }
    }
    
    @objc func btnNextPressed(_ sender: UIButton) {
        if pages.indices.contains(currentIndex+1) {
            self.setViewControllers([pages[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            self.currentIndex = currentIndex + 1
            self.changePageIndicator()
        } else {
            APIHelper.shared.landingPage = "login"
            self.navigationController?.pushViewController(Initialvc(), animated: true)
        }
       
    }
    
    @objc func btnSkipPressed(_ sender: UIButton) {
        APIHelper.shared.landingPage = "login"
        self.navigationController?.pushViewController(Initialvc(), animated: true)
    }

}
extension PageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        if let currentIndex = pages.firstIndex(of: viewController), pages.indices.contains(currentIndex+1) {
            self.currentIndex = currentIndex+1
            return pages[currentIndex+1]
            
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pages.firstIndex(of: viewController), pages.indices.contains(currentIndex-1) {
            self.currentIndex = currentIndex-1
            return pages[currentIndex-1]
        }
        return nil
    }
}
extension PageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = self.viewControllers?.first as? OnboardScreenVC {
            
            self.currentIndex = vc.pageIndex
            self.changePageIndicator()
           
        }
    }
}
