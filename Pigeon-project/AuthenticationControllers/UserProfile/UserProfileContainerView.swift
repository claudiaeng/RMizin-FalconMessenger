//
//  UserProfileContainerView.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/4/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


class BioTextView: UITextView {
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
}

class PasteRestrictedTextField: UITextField {
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
}

class UserProfileContainerView: UIView {
  
  lazy var profileImageView: UIImageView = {
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.borderWidth = 1
    profileImageView.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
    profileImageView.layer.cornerRadius = 48
    profileImageView.isUserInteractionEnabled = true
    return profileImageView
  }()
  
  let addPhotoLabel: UILabel = {
    let addPhotoLabel = UILabel()
    addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
    addPhotoLabel.text = "Add\nphoto"
    addPhotoLabel.numberOfLines = 2
    addPhotoLabel.font = UIFont(name: "Avenir-Book", size: 14)
    addPhotoLabel.textColor = UIColor.black
    addPhotoLabel.textAlignment = .center
    
    return addPhotoLabel
  }()
  
  var name: PasteRestrictedTextField = {
    let name = PasteRestrictedTextField()
    name.font = UIFont(name: "Avenir-Book", size: 14)
    name.enablesReturnKeyAutomatically = true
    name.translatesAutoresizingMaskIntoConstraints = false
    name.textAlignment = .center
    name.placeholder = "Enter name"
    name.borderStyle = .none
    name.autocorrectionType = .no
    name.returnKeyType = .done
    name.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
    name.textColor = ThemeManager.currentTheme().generalTitleColor
  
    return name
  }()
  
  let phone: PasteRestrictedTextField = {
    let phone = PasteRestrictedTextField()
    phone.font = UIFont(name: "Avenir-Book", size: 14)
    phone.translatesAutoresizingMaskIntoConstraints = false
    phone.textAlignment = .center
    phone.keyboardType = .numberPad
    phone.placeholder = "Phone Number"
    phone.borderStyle = .none
    phone.isEnabled = false
    phone.textColor = ThemeManager.currentTheme().generalSubtitleColor
    phone.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
   
    return phone
  }()
    
    let cityPlaceholderLabel: UILabel = {
        let bioPlaceholderLabel = UILabel()
        bioPlaceholderLabel.text = "City"
        bioPlaceholderLabel.sizeToFit()
        bioPlaceholderLabel.textAlignment = .center
        bioPlaceholderLabel.backgroundColor = .clear
        bioPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        bioPlaceholderLabel.textColor = ThemeManager.currentTheme().generalSubtitleColor
        
        return bioPlaceholderLabel
    }()
  
  let bioPlaceholderLabel: UILabel = {
    let bioPlaceholderLabel = UILabel()
    bioPlaceholderLabel.text = "Bio"
    bioPlaceholderLabel.sizeToFit()
    bioPlaceholderLabel.textAlignment = .center
    bioPlaceholderLabel.backgroundColor = .clear
    bioPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
    bioPlaceholderLabel.textColor = ThemeManager.currentTheme().generalSubtitleColor

    return bioPlaceholderLabel
  }()
  
  let userData: UIView = {
    let userData = UIView()
    userData.translatesAutoresizingMaskIntoConstraints = false
    userData.layer.cornerRadius = 30
    userData.layer.borderWidth = 1
    userData.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
    
    return userData
  }()
    
    let city: BioTextView = {
        let bio = BioTextView()
        bio.translatesAutoresizingMaskIntoConstraints = false
        bio.layer.cornerRadius = 28
        bio.layer.borderWidth = 1
        bio.textAlignment = .center
        bio.font = UIFont(name: "Avenir-Book", size: 14)
        bio.isScrollEnabled = false
        bio.textContainerInset = UIEdgeInsets(top: 15, left: 35, bottom: 15, right: 35)
        bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
        bio.backgroundColor = .clear
        bio.textColor = ThemeManager.currentTheme().generalTitleColor
        bio.indicatorStyle = ThemeManager.currentTheme().scrollBarStyle
        bio.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
        bio.textContainer.lineBreakMode = .byTruncatingTail
        bio.returnKeyType = .done
        
        return bio
    }()

  let bio: BioTextView = {
    let bio = BioTextView()
    bio.translatesAutoresizingMaskIntoConstraints = false
    bio.layer.cornerRadius = 28
    bio.layer.borderWidth = 1
    bio.textAlignment = .center
    bio.font = UIFont(name: "Avenir-Book", size: 14)
    bio.isScrollEnabled = false
    bio.textContainerInset = UIEdgeInsets(top: 15, left: 35, bottom: 15, right: 35)
    bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
    bio.backgroundColor = .clear
    bio.textColor = ThemeManager.currentTheme().generalTitleColor
    bio.indicatorStyle = ThemeManager.currentTheme().scrollBarStyle
    bio.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
    bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
    bio.textContainer.lineBreakMode = .byTruncatingTail
    bio.returnKeyType = .done
   
    return bio
  }()
  
  let countLabel: UILabel = {
    let countLabel = UILabel()
    countLabel.translatesAutoresizingMaskIntoConstraints = false
    countLabel.sizeToFit()
    countLabel.textColor = UIColor.white
    countLabel.isHidden = true
    countLabel.font = UIFont(name: "Avenir-Book", size: 14)
    return countLabel
  }()
  
  let bioMaxCharactersCount = 50

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    
    addSubview(addPhotoLabel)
    addSubview(profileImageView)
    addSubview(userData)
    addSubview(bio)
    addSubview(city)
    addSubview(countLabel)
    userData.addSubview(name)
    userData.addSubview(phone)
    bio.addSubview(bioPlaceholderLabel)
    city.addSubview(cityPlaceholderLabel)
  
      NSLayoutConstraint.activate([
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
        profileImageView.widthAnchor.constraint(equalToConstant: 100),
        profileImageView.heightAnchor.constraint(equalToConstant: 100),
        
        addPhotoLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
        addPhotoLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        addPhotoLabel.widthAnchor.constraint(equalToConstant: 100),
        addPhotoLabel.heightAnchor.constraint(equalToConstant: 100),

        userData.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0),
        userData.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
        userData.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0),
        
        name.topAnchor.constraint(equalTo: userData.topAnchor, constant: 0),
        name.leftAnchor.constraint(equalTo: userData.leftAnchor, constant: 0),
        name.rightAnchor.constraint(equalTo: userData.rightAnchor, constant: 0),
        name.heightAnchor.constraint(equalToConstant: 50),
        
        phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0),
        phone.leftAnchor.constraint(equalTo: userData.leftAnchor, constant: 0),
        phone.rightAnchor.constraint(equalTo: userData.rightAnchor, constant: 0),
        phone.heightAnchor.constraint(equalToConstant: 50),
        
        city.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
        bio.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 10),

        countLabel.widthAnchor.constraint(equalToConstant: 30),
        countLabel.heightAnchor.constraint(equalToConstant: 30),
        countLabel.rightAnchor.constraint(equalTo: bio.rightAnchor, constant: -5),
        countLabel.bottomAnchor.constraint(equalTo: bio.bottomAnchor, constant: -5),
        cityPlaceholderLabel.centerXAnchor.constraint(equalTo: city.centerXAnchor, constant: 0),
        cityPlaceholderLabel.centerYAnchor.constraint(equalTo: city.centerYAnchor, constant: 0),
        
        bioPlaceholderLabel.centerXAnchor.constraint(equalTo: bio.centerXAnchor, constant: 0),
        bioPlaceholderLabel.centerYAnchor.constraint(equalTo: bio.centerYAnchor, constant: 0),
      ])
    
    bioPlaceholderLabel.font = UIFont(name: "Avenir-Book", size: 14)
    bioPlaceholderLabel.isHidden = !bio.text.isEmpty
    cityPlaceholderLabel.font = UIFont(name: "Avenir-Book", size: 14)
    cityPlaceholderLabel.isHidden = !city.text.isEmpty
    
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
        bio.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
        bio.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        city.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
        city.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        userData.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
      ])
    } else {
      NSLayoutConstraint.activate([
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        bio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        bio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        city.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        city.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        userData.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      ])
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}
