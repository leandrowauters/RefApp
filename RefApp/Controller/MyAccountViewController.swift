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

    @IBOutlet weak var countryFlagImage: UIImageView!
    
    
    
    
    let infoView: MyAccountInfoView = Bundle.main.loadNibNamed("MyAccountInfoView", owner: self, options: nil)?.first as! MyAccountInfoView
    let previousGamesView: PreviousGamesView = Bundle.main.loadNibNamed("PreviousGamesView", owner: self, options: nil)?.first as! PreviousGamesView
    
    lazy var customSegmentedBar: UISegmentedControl = graphics.segmentedControlBar(titles: ["Info", "Previous Games"], numberOfSegments: 2)
    lazy var animatedView: UIView = graphics.animatedView
    lazy var animatedViewRail: UIView = graphics.animatedViewRail
    var views = [UIView]()
    private var usersession: UserSession!
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    var referee: Referee!
    var userLoggedIn = Bool()
    var graphics = GraphicClient()
    var gameStatisticInfo = [String](){
        didSet{
            infoView.infoTableView.reloadData()
        }
    }
    var gameStatistics = [GameStatistics]() {
        didSet{
            gameStatisticInfo = TotalStatistics.getTotalStatistics(gameStatistics: gameStatistics)
        }
    }
    var gameData = [GameData]() {
        didSet{
            previousGamesView.previousGamesTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [infoView,previousGamesView]
        setupSegmentedBar()
        infoView.infoTableView.delegate = self
        infoView.infoTableView.dataSource = self
        infoView.infoTableView.tableFooterView = UIView()
        previousGamesView.previousGamesTableView.tableFooterView = UIView()
        previousGamesView.previousGamesTableView.delegate = self
        previousGamesView.previousGamesTableView.dataSource = self
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.usersessionSignOutDelegate = self
        graphics.setupAnimatedViewRail(view: view, animatedViewRail: animatedViewRail, customSegmentedBar: customSegmentedBar)
        graphics.setupAnimatedView(view: view, animatedView: animatedView, customSegmentedBar: customSegmentedBar, numberOfSegments: 2)
        getGameStatistics()
        getGameData()
        graphics.changeImageToRound(image: profileImage)
        setupCountryFlag()
        checkForCountryFlagURL()
        setupLabels()
        setupProfileImage()
        setupViews(views: views)
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
        
    }

    func checkForCountryFlagURL(){
        if let country = referee.country{
        CountryAPIClient.getCountyAlphaCode(country: country) { (error, code) in
            if let error = error {
                print(error)
            }
            if let code = code{
                CountryAPIClient.getCountryFlagUrl(countryAlpahaCode: code, completion: { (error, flagURL) in
                    if let error = error {
                        print(error)
                    }
                    if let flagURL = flagURL {
                        DispatchQueue.main.async {
                            self.countryFlagImage.kf.setImage(with: URL(string: flagURL))
                        }
                    }
                })
            }
        }
        }
    }
    func getGameStatistics() {
        if let user = usersession.getCurrentUser(){
        DatabaseManager.fetchGameStatistics(vc: self, user: user) { (error, gameStatistics) in
            if let gameStatisitcs = gameStatistics {
                self.gameStatistics = gameStatisitcs
            }
        }
        }
    }
    func getGameData(){
        if let user = usersession.getCurrentUser(){
            DatabaseManager.fetchGameData(vc: self, user: user) { (error, gameData) in
                if let gameData = gameData {
                    self.gameData = gameData
                }
            }
        }
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
        
    }
    func setupLabels() {
        profileNameLabel.text = referee.displayName ?? ""
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
        customSegmentedBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoView.infoTableView{
        return gameStatisticInfo.count
        } else {
            return gameData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myAccountCell")
        cell.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        tableView.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        if tableView == infoView.infoTableView{
        let statToSet = gameStatisticInfo[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = statToSet
        } else {
            let dataToSet = gameData[indexPath.row]
            cell.textLabel?.text = "\(dataToSet.homeTeam) vs. \(dataToSet.awayTeam)"
            cell.detailTextLabel?.text = dataToSet.dateAndTime
            cell.detailTextLabel?.font = graphics.getHiraginoSansFont(W3: true, size: 15)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "gameSummary") as? GameSummaryViewController else {return}
        vc.gameData = gameData[indexPath.row]
        vc.rootViewController = .myAccount
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
}
