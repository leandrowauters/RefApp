//
//  CreateAccountViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
class CreateAccountViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        return ip
    }()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    
    private var usersession: UserSession!
    private var storageManager: StorageManager!
    private var userImage: UIImage?
    private var displayName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        usersession.userSessionAccountDelegate = self
        storageManager.delegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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

        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let username = usernameTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !username.isEmpty else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
            } else {
            usersession.createNewAccount(displayName: username, email: email, password: password, confirmPassoword: confirmPassword)
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
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
}
    
extension CreateAccountViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
        // update the auth user's photoURL
        usersession.updateUser(photoURL: imageURL)
    }
}
