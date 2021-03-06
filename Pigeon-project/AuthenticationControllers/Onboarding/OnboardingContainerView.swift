//
//  OnboardingContainerView.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class OnboardingContainerView: UIView {

  let logoImageView: UIImageView = {
    let logoImageView = UIImageView()
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = UIImage(named: "logo")
    logoImageView.contentMode = .scaleAspectFit
    return logoImageView
  }()
  
  let welcomeTitle: UILabel = {
    let welcomeTitle = UILabel()
    welcomeTitle.translatesAutoresizingMaskIntoConstraints = false
    welcomeTitle.text = "Your Best Career Resource"
    welcomeTitle.font = UIFont(name: "Avenir-Book", size: 14)
    welcomeTitle.textAlignment = .center
    welcomeTitle.textColor = ThemeManager.currentTheme().generalTitleColor
    return welcomeTitle
  }()
  
  let startMessaging: UIButton = {
    let startMessaging = UIButton()
    startMessaging.translatesAutoresizingMaskIntoConstraints = false
    startMessaging.setTitle("Start Networking", for: .normal)
    startMessaging.setTitleColor(.black, for: .normal)
    startMessaging.titleLabel?.backgroundColor = .clear
    startMessaging.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14)
    startMessaging.addTarget(self, action: #selector(OnboardingController.startMessagingDidTap), for: .touchUpInside)
    
    return startMessaging
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    addSubview(logoImageView)
    addSubview(welcomeTitle)
    addSubview(startMessaging)
    
    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
      logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
      logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
      logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
      
      startMessaging.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      startMessaging.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      startMessaging.heightAnchor.constraint(equalToConstant: 50),
      
      welcomeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      welcomeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      welcomeTitle.heightAnchor.constraint(equalToConstant: 50),
      welcomeTitle.bottomAnchor.constraint(equalTo: startMessaging.topAnchor, constant: -10)
    ])
    
    if #available(iOS 11.0, *) {
       startMessaging.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
    } else {
       startMessaging.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}
