//
//  AuthVerificationController.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 3/30/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit


class AuthVerificationController: EnterVerificationCodeController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setRightBarButton(with: "Next")
    self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 15)!], for: .normal)
    
    //navigationItem.title = "Profile"
    self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 15)!]
  }
  
  override func rightBarButtonDidTap() {
    super.rightBarButtonDidTap()
    authenticate()
  }
}
