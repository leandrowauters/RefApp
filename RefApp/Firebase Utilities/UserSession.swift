//
//  UserSession.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseAuth

enum AccountLoginState {
    case newAccount
    case existingAccount
}
protocol UserSessionAccountCreationDelegate: AnyObject {
    func didCreateAccount(_ userSession: UserSession, user: User)
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error)
}

protocol UserSessionSignOutDelegate: AnyObject {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error)
    func didSignOutUser(_ usersession: UserSession)
}

protocol UserSessionSignInDelegate: AnyObject {
    func didRecieveSignInError(_ usersession: UserSession, error: Error)
    func didSignInExistingUser(_ usersession: UserSession, user: User)
}
final class UserSession {
    static var loginStatus: AccountLoginState = .newAccount
    weak var userSessionAccountDelegate: UserSessionAccountCreationDelegate?
    weak var usersessionSignOutDelegate: UserSessionSignOutDelegate?
    weak var usersessionSignInDelegate: UserSessionSignInDelegate?

    public func createNewAccount(email: String, password: String, confirmPassoword: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.userSessionAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.userSessionAccountDelegate?.didCreateAccount(self, user: authDataResult.user)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signInExistingUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.usersessionSignInDelegate?.didRecieveSignInError(self, error: error)
            } else if let authDataResult = authDataResult {
                self.usersessionSignInDelegate?.didSignInExistingUser(self, user: authDataResult.user)
            }
        }
    }
    
    public func signOut() {
        guard let _ = getCurrentUser() else {
            print("no logged user")
            return
        }
        do {
            try Auth.auth().signOut()
            usersessionSignOutDelegate?.didSignOutUser(self)
        } catch {
            usersessionSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
}
