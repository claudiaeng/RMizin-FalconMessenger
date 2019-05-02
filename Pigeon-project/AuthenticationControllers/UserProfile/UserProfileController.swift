//
//  UserProfileController.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress

class UserProfileController: UIViewController {
    
    var window: UIWindow?
    
    let userProfileContainerView = UserProfileContainerView()
    let avatarOpener = AvatarOpener()
    let userProfileDataDatabaseUpdater = UserProfileDataDatabaseUpdater()
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        view.addSubview(userProfileContainerView)
        
        configureNavigationBar()
        configureContainerView()
        configureColorsAccordingToTheme()
    }
    
    fileprivate func configureNavigationBar () {
        let rightBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(rightBarButtonDidTap))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.title = "Profile"
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    fileprivate func configureContainerView() {
        userProfileContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        userProfileContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        userProfileContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        /*
         userProfileContainerView.frame = view.bounds
         if #available(iOS 11.0, *) {
         userProfileContainerView.insetsLayoutMarginsFromSafeArea = true
         } else {
         // Fallback on earlier versions
         }
         */
        userProfileContainerView.bioPlaceholderLabel.isHidden = !userProfileContainerView.bio.text.isEmpty
                userProfileContainerView.cityPlaceholderLabel.isHidden = !userProfileContainerView.city.text.isEmpty
        userProfileContainerView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfilePicture)))
        userProfileContainerView.bio.delegate = self
        userProfileContainerView.name.delegate = self
    }
    
    fileprivate func configureColorsAccordingToTheme() {
        userProfileContainerView.profileImageView.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.userData.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.name.textColor = ThemeManager.currentTheme().generalTitleColor
        userProfileContainerView.bio.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.bio.textColor = ThemeManager.currentTheme().generalTitleColor
        userProfileContainerView.bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
        userProfileContainerView.name.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileContainerView.frame = view.bounds
        userProfileContainerView.layoutIfNeeded()
    }
    
    @objc fileprivate func openUserProfilePicture() {
        guard currentReachabilityStatus != .notReachable else {
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: noInternetError, controller: self)
            return
        }
        avatarOpener.delegate = self
        avatarOpener.handleAvatarOpening(avatarView: userProfileContainerView.profileImageView, at: self,
                                         isEditButtonEnabled: true, title: .user)
    }
}

extension UserProfileController {
    
    @objc func rightBarButtonDidTap () {
        let tabBarController = TabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        tabBarController.presentOnboardingController()
        
        if userProfileContainerView.name.text?.count == 0 ||
            userProfileContainerView.name.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            userProfileContainerView.name.shake()
        } else {
            
            if currentReachabilityStatus == .notReachable {
                basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
                return
            }
            
            updateUserData()
            setOnlineStatus()
        }
    }
    
    func checkIfUserDataExists(completionHandler: @escaping CompletionHandler) {
        
        let nameReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("name")
        nameReference.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.userProfileContainerView.name.text = snapshot.value as? String
            }
        })
        
        let bioReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("bio")
        bioReference.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.userProfileContainerView.bio.text = snapshot.value as? String
            }
        })
        
        let cityReference = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        cityReference.addSnapshotListener({ (doc, err) in
            if err == nil {
                let city = doc?.data()
                self.userProfileContainerView.city.text = city?["city"] as? String
            }
        })
        
        let photoReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("photoURL")
        photoReference.observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                guard let urlString = snapshot.value as? String else { return }
                self.userProfileContainerView.profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: [.scaleDownLargeImages , .continueInBackground], completed: { (_, _, _, _) in
                    completionHandler(true)
                })
            } else {
                completionHandler(true)
            }
        })
    }
    
    func updateUserData() {
        ARSLineProgress.ars_showOnView(self.view)
        
        let firRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        firRef.setData(["userName": self.userProfileContainerView.name.text!, "city": self.userProfileContainerView.city.text!,
                           "phoneNumber": self.userProfileContainerView.phone.text!,
                           "bio": self.userProfileContainerView.bio.text!]) { (err) in
                            if err != nil {
                                print(err as Any)
                            }
        }
        
        let userReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        userReference.updateChildValues(["name": userProfileContainerView.name.text!,
                                         "phoneNumber": userProfileContainerView.phone.text!,
                                         "bio": userProfileContainerView.bio.text!]) { (_, _) in
                                            ARSLineProgress.hide()
                                            self.dismiss(animated: true) {
                                                AppUtility.lockOrientation(.allButUpsideDown)
                                            }
                                            
        }
    }
    
    
    
    
}

extension UserProfileController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        userProfileContainerView.bioPlaceholderLabel.isHidden = true
        userProfileContainerView.cityPlaceholderLabel.isHidden = true
        userProfileContainerView.countLabel.text = "\(userProfileContainerView.bioMaxCharactersCount - userProfileContainerView.bio.text.count)"
        userProfileContainerView.countLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        userProfileContainerView.bioPlaceholderLabel.isHidden = !textView.text.isEmpty
        userProfileContainerView.cityPlaceholderLabel.isHidden = !textView.text.isEmpty
        userProfileContainerView.countLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.isFirstResponder && textView.text == "" {
            userProfileContainerView.bioPlaceholderLabel.isHidden = true
            userProfileContainerView.cityPlaceholderLabel.isHidden = true
        } else {
            userProfileContainerView.bioPlaceholderLabel.isHidden = !textView.text.isEmpty
            userProfileContainerView.cityPlaceholderLabel.isHidden = !textView.text.isEmpty
        }
        userProfileContainerView.countLabel.text = "\(userProfileContainerView.bioMaxCharactersCount - textView.text.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= userProfileContainerView.bioMaxCharactersCount
    }
}

extension UserProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
