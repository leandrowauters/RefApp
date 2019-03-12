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
protocol UserDidLogInDelegate: AnyObject {
    func userDidLogin()
}
protocol UserSessionUpdateDelegate: AnyObject {
    func didRecieveUpdateError(_ usersession: UserSession, error: Error)
    func didUpdateExistingUser(_ usersession: UserSession, user: User)
}
protocol UserDidUpdateDelegate: AnyObject {
    func userDidUpdate(referee: Referee)
}
final class UserSession {
    static var loginStatus: AccountLoginState = .newAccount
    private var storageManager: StorageManager!
    weak var userSessionAccountDelegate: UserSessionAccountCreationDelegate?
    weak var usersessionSignOutDelegate: UserSessionSignOutDelegate?
    weak var usersessionSignInDelegate: UserSessionSignInDelegate?
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    weak var userUpdateDelegate: UserSessionUpdateDelegate?
    weak var userDidUpdateDelegate: UserDidUpdateDelegate?
    
    public func createNewAccount(email: String, password: String, confirmPassoword: String, firstName: String, lastName: String, country: String?) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.userSessionAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.userSessionAccountDelegate?.didCreateAccount(self, user: authDataResult.user)
                let request = authDataResult.user.createProfileChangeRequest()
                request.displayName = "\(lastName), \(firstName)"
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        print("error: \(error)")
                    } else {
                        guard let username = authDataResult.user.email?.components(separatedBy: "@").first else {
                            print("no email entered")
                            return
                        }
                        // add user to database
                        // use the user.uid as the document id for ease of use when updating / querying current user
                        DatabaseManager.firebaseDB.collection(DatabaseKeys.UsersCollectionKey)
                            .document(authDataResult.user.uid.description)
                            .setData(["userId"      : authDataResult.user.uid,
                                      "email"       : authDataResult.user.email ?? "",
                                      "displayName" : authDataResult.user.displayName ?? "",
                                      "imageURL"    : authDataResult.user.photoURL ?? "",
                                      "firstName"   : firstName,
                                      "lastName"    : lastName,
                                      "username"    : username,
                                      "country"     : country ?? ""
                                
                                ], completion: { (error) in
                                    if let error = error {
                                        print("error adding authenticated user to the database: \(error)")
                                    }
                            })
                    }
                })

            }
        }
    }
    public func updateRefereeInfo(email: String, firstName: String, lastName: String, country: String?){
        if let user = getCurrentUser(){
            let request = user.createProfileChangeRequest()
            request.displayName = "\(lastName), \(firstName)"
            request.commitChanges { (error) in
                if let error = error {
                    self.userUpdateDelegate?.didRecieveUpdateError(self, error: error)
                    
                } else {
                    self.userUpdateDelegate?.didUpdateExistingUser(self, user: user)
                    guard let username = user.email?.components(separatedBy: "@").first else {
                        print("no email entered")
                        return
                    }
                    DatabaseManager.firebaseDB.collection(DatabaseKeys.UsersCollectionKey).document(user.uid.description).updateData(["email" : user.email ?? "","displayName" : user.displayName ?? "","firstName"   : firstName, "lastName"    : lastName, "username"    : username,"country"     : country ?? ""], completion: { (error) in
                        if let error = error {
                            print("error adding authenticated user to the database: \(error)")
                        }
                    })
                    
                    
                }
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
                UserSession.loginStatus = .existingAccount
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
            UserSession.loginStatus = .newAccount
            usersessionSignOutDelegate?.didSignOutUser(self)
        } catch {
            usersessionSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
    public func updateUser(photoURL: URL?) {
        guard let user = getCurrentUser() else {
            print("no logged user")
            return
        }
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        request.commitChanges { (error) in
            if let error = error {
                print("error: \(error)")
            } else {
                // update database user as well
                guard let photoURL = photoURL else {
                    print("no photoURL")
                    return
                }
                DatabaseManager.firebaseDB
                    .collection(DatabaseKeys.UsersCollectionKey)
                    .document(user.uid) // making the user document id the same as the auth userId makes it easy to update the user doc
                    .updateData(["imageURL": photoURL.absoluteString], completion: { (error) in
                        guard let error = error else {
                            print("successfully ")
                            return
                        }
                        print("updating photo url error: \(error.localizedDescription)")
                        
                    })
            
        }
    }
    }
}
