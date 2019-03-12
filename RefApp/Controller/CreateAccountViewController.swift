//
//  CreateAccountViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class CreateAccountViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        return ip
    }()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var conteinerView: UIView!
    
    @IBOutlet var labelsTohide: [UILabel]!
    @IBOutlet var editButtons: [UIButton]!
    
    @IBOutlet weak var createButton: UIButton!
    
    
    private var usersession: UserSession!
    private var storageManager: StorageManager!
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    weak var userDidUpdatedDelegate: UserDidUpdateDelegate?
    var intention: Intention!
    var referee: Referee!
    private var userImage: UIImage?
    private var displayName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        countryTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        usersession.userSessionAccountDelegate = self
        usersession.userUpdateDelegate = self
        setupUI()
        storageManager.delegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    func setupUI(){
        
        if intention == .edit {
            if let imageURL = referee.imageURL{
                profileImageButton.kf.setImage(with: URL(string: imageURL), for: .normal)
            }
            createButton.translatesAutoresizingMaskIntoConstraints = false
            createButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40).isActive = true
            createButton.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
            createButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
            createButton.setTitle("Done", for: .normal)
            firstNameTextField.isEnabled = false
            firstNameTextField.text = referee.firstName
            firstNameTextField.textColor = #colorLiteral(red: 0.1726308763, green: 0.1726359427, blue: 0.1726332307, alpha: 1)
            lastNameTextField.isEnabled = false
            lastNameTextField.text = referee.lastName
            lastNameTextField.textColor = #colorLiteral(red: 0.1726308763, green: 0.1726359427, blue: 0.1726332307, alpha: 1)
            countryTextField.isEnabled = false
            countryTextField.text = referee.country
            countryTextField.textColor = #colorLiteral(red: 0.1726308763, green: 0.1726359427, blue: 0.1726332307, alpha: 1)
            emailTextField.isEnabled = false
            emailTextField.text = referee.email
            emailTextField.textColor = #colorLiteral(red: 0.1726308763, green: 0.1726359427, blue: 0.1726332307, alpha: 1)
            labelsTohide.forEach{$0.isHidden = true}
            passwordTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            editButtons.forEach{$0.isHidden = false}
            
        } else {
            editButtons.forEach{$0.isHidden = true}
        }
    }

    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc private func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("UserInfo is nil")
                return
        }
        conteinerView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    @objc private func willHideKeyboard(){
        conteinerView.transform = CGAffineTransform.identity
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func editPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            firstNameTextField.isEnabled = true
            firstNameTextField.becomeFirstResponder()
        case 1:
            lastNameTextField.isEnabled = true
            lastNameTextField.becomeFirstResponder()
        case 2:
            countryTextField.isEnabled = true
            countryTextField.becomeFirstResponder()
        case 3:
            emailTextField.isEnabled = true
            emailTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.showImagePickerController()
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }
    private func showImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func createUserPressed(_ sender: UIButton) {
        if intention == .edit{
            guard let email = emailTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !email.isEmpty,
            !firstName.isEmpty,
                !lastName.isEmpty else {
                    showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                    return
            }
            if let country = countryTextField.text {
                usersession.updateRefereeInfo(email: email, firstName: firstName, lastName: lastName, country: country)
            } else {
                usersession.updateRefereeInfo(email: email, firstName: firstName, lastName: lastName, country: nil)
            }
        } else {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
            } else {
            if let country = countryTextField.text{
                usersession.createNewAccount(email: email, password: password, confirmPassoword: confirmPassword, firstName: firstName, lastName: lastName, country: country)
            } else {
                usersession.createNewAccount(email: email, password: password, confirmPassoword: confirmPassword, firstName: firstName, lastName: lastName, country: nil)
            }
//            usersession.createNewAccount(displayName: username, email: email, password: password, confirmPassoword: confirmPassword)
            }
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error with Image", message: "Try Again")
            return
        }
        userImage = originalImage
        profileImageButton.setImage(originalImage, for: .normal)
        dismiss(animated: true)
//        guard let imageData = originalImage.jpegData(compressionQuality: 0.5) else {
//            print("failed to create data from image")
//            return
//        }
//        // save the image to Firebase Storage
//        storageManager.postImage(withData: imageData)
    }
}
extension CreateAccountViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ userSession: UserSession, user: User) {
        if let image = userImage{
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                storageManager.postImage(withData: imageData)
            }
        }
        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "no email entered") ") { alertController in
            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let myAccountVC = storyboard.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountViewController else {return}
                myAccountVC.modalPresentationStyle = .overCurrentContext
                self.userDidLoginDelegate?.userDidLogin()
//                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
}
extension CreateAccountViewController: UserSessionUpdateDelegate{
    func didRecieveUpdateError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Account Update Error", message: error.localizedDescription)
    }
    
    func didUpdateExistingUser(_ usersession: UserSession, user: User) {
        
        showAlert(title: "Account Updated", message: "Account updated") { alertController in
            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
                DatabaseManager.fetchReferee(vc: self, user: user) { (error, referee) in
                    if let error = error {
                        print(error)
                    }
                    if let referee = referee {
                       self.userDidUpdatedDelegate?.userDidUpdate(referee: referee)
                       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    
}
extension CreateAccountViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
        // update the auth user's photoURL
        usersession.updateUser(photoURL: imageURL)
    }
}
extension CreateAccountViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .white
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
