//
//  MyAccountViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileCountryLabel: UILabel!
    @IBOutlet weak var countryFlagImage: UIImageView!
    
    
    
    
    let infoView: MyAccountInfoView = Bundle.main.loadNibNamed("MyAccountInfoView", owner: self, options: nil)?.first as! MyAccountInfoView
    let previousGamesView: PreviousGamesView = Bundle.main.loadNibNamed("PreviousGamesView", owner: self, options: nil)?.first as! PreviousGamesView
    lazy var customSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Info", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Previous Games", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        return segmentedControl
    }()
    
    lazy var animatedView: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var animatedViewRail: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        return view
    }()
    var views = [UIView]()
    private var usersession: UserSession!
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    var referee: Referee!
    var userLoggedIn = Bool()
    var graphics = GraphicClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [infoView,previousGamesView]
        setupSegmentedBar()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.usersessionSignOutDelegate = self
        setupAnimatedViewRail()
        setupAnimatedView()
//        setupCountryFlag()
        setupLabels()
        setupProfileImage()
        setupViews(views: views)
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
        
    }
    @IBAction func signOutPressed(_ sender: UIButton) {
        usersession.signOut()
        UserSession.loginStatus = .newAccount
        userDidLoginDelegate?.userDidLogin()
    }
    @IBAction func closeWindowPressed(_ sender: UIButton) {
        if userLoggedIn{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            userDidLoginDelegate?.userDidLogin()
        } else {
            dismiss(animated: true, completion: nil)
            userDidLoginDelegate?.userDidLogin()
        }
    }
    func setupCountryFlag(){
        graphics.getCountyFlagURL(country: referee.country ?? "") { (error, flagURL) in
            if let error = error{
                print(error)
            }
            if let flagURL = flagURL {
                if let url = URL(string: flagURL) {
                    DispatchQueue.main.async {
                        self.countryFlagImage.kf.setImage(with: url, placeholder: UIImage(named: "userImage"), options: [], progressBlock: nil, completionHandler: { (result) in
                            switch result {
                            case .success(let value):
                                // The image was set to image view:
                                print(value.image)
                                
                                // From where the image was retrieved:
                                // - .none - Just downloaded.
                                // - .memory - Got from memory cache.
                                // - .disk - Got from disk cache.
                                print(value.cacheType)
                                
                                // The source object which contains information like `url`.
                                print(value.source)
                                
                            case .failure(let error):
                                print(error) // The error happens
                            }
                        })
                    }
                }

            }
        }
    }
    func setupLabels() {
        profileNameLabel.text = referee.displayName ?? ""
        profileCountryLabel.text = referee.country ?? ""
    }
    func setupProfileImage(){
        if let imageURL = referee.imageURL{
            profileImage.kf.indicatorType = .activity
            profileImage.kf.setImage(with: URL(string: imageURL))
        }
    }
    func setupViews(views: [UIView]){
        for view in views{
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: animatedView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.isHidden = true
        }
        views.first?.isHidden = false
    }
    func setupSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customSegmentedBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customSegmentedBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupAnimatedView(){
        view.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
    }
    func setupAnimatedViewRail(){
        view.addSubview(animatedViewRail)
        animatedViewRail.translatesAutoresizingMaskIntoConstraints = false
        animatedViewRail.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedViewRail.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedViewRail.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedViewRail.widthAnchor.constraint(equalTo: customSegmentedBar.widthAnchor).isActive = true
    }
    @objc func customSegmentedBarPressed(sender: UISegmentedControl){
        for i in 0...views.count - 1 {
            if i == sender.selectedSegmentIndex{
                views[i].isHidden = false
            } else {
                views[i].isHidden = true
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.animatedView.frame.origin.x = (self.customSegmentedBar.frame.width / CGFloat(self.customSegmentedBar.numberOfSegments)) * CGFloat(self.customSegmentedBar.selectedSegmentIndex)
        }
    }

}
extension MyAccountViewController: UserSessionSignOutDelegate{
    
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Error signing out", message: error.localizedDescription)
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        showAlert(title: "Succesfully signed out", message: nil) { (alert) in
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                if self.userLoggedIn{
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
