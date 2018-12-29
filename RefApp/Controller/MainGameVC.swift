//
//  MainGameVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class MainGameVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var teamsScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsScrollView.delegate = self
        let views:[UIView] = createViews()
        setupSlideScrollViews(views: views)
        pageControll.numberOfPages = views.count
        pageControll.currentPage = 0
        view.bringSubviewToFront(pageControll)
        
    }
    func createViews () -> [UIView] {
        let view1: HomeView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! HomeView
        view1.testLabel.text = "View 1"
        let view2: AwayView = Bundle.main.loadNibNamed("AwayView", owner: self, options: nil)?.first as! AwayView
        view2.testLabel.text = "View 2"
        
    return [view1, view2]
    }
    func setupSlideScrollViews(views: [UIView]){
        teamsScrollView.frame = CGRect (x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        teamsScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height / 2)
        teamsScrollView.isPagingEnabled = true
        for i in 0...views.count - 1 {
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height / 2)
        teamsScrollView.addSubview(views[i])
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
    }
}

