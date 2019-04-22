//
//  ContactsFetcher.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/20/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import SDWebImage


protocol ContactsUpdatesDelegate: class {
    func connections(updateDatasource contacts: [User])
    func contacts(handleAccessStatus: Bool)
}

class ContactsFetcher: NSObject {
    
    weak var delegate: ContactsUpdatesDelegate?
    
    
    func getFilteredDeepDataFromFireStore(collectionName: String, filter: String, filter2: String, query: String, queryValue: Any, completionHandler : @escaping (_ success: Bool, _ dataArray: [[String: Any]]) -> ()){
        
        Firestore.firestore().collection(collectionName).document(filter).collection(filter2).whereField(query, isEqualTo: queryValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(false,[[String: AnyObject]]())
            } else {
                
                if let documents = querySnapshot?.documents{
                    var documentsArray = [[String: Any]]()
                    for document in documents{
                        documentsArray.append(document.data())
                    }
                    completionHandler(true, documentsArray)
                }
            }
        }
        
    }
    
    func fetchContacts () {
        
        /*
         let status = CNContactStore.authorizationStatus(for: .contacts)
         let store = CNContactStore()
         if status == .denied || status == .restricted {
         delegate?.contacts(handleAccessStatus: false)
         return
         }
         
         store.requestAccess(for: .contacts) { granted, error in
         guard granted, error == nil else {
         self.delegate?.contacts(handleAccessStatus: false)
         return
         }
         
         self.delegate?.contacts(handleAccessStatus: true)
         
         let keys = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey]
         let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
         */
        var connections = [User]()
        var phoneNumbers = [String]()
        var phones = [String]()
        
        func getContacts() {
            
            getFilteredDeepDataFromFireStore(collectionName: "users", filter: Auth.auth().currentUser?.uid ?? "", filter2: "friends", query: "accepted", queryValue: true) { isSuccess,data in
                
                if isSuccess{
                    for d in data {
                        let number = "\(d["phoneNumber"] ?? "")"
                        phones.append(number)
                        print(number)
                        let userReference = Database.database().reference().child("users")
                        let userQuery = userReference.queryOrdered(byChild: "phoneNumber")
                        let databaseHandle = DatabaseHandle()
                        var userHandle = [DatabaseHandle]()
                        userHandle.insert(databaseHandle, at: 0 )
                        userHandle[0] = userQuery.queryEqual(toValue: number).observe(.value, with: { (snapshot) in
                            if snapshot.exists() {
                                guard let children = snapshot.children.allObjects as? [DataSnapshot] else { return }
                                for child in children {
                                    guard var dictionary = child.value as? [String: AnyObject] else { return }
                                    dictionary.updateValue(child.key as AnyObject, forKey: "id")
                                    if let thumbnailURLString = User(dictionary: dictionary).thumbnailPhotoURL, let thumbnailURL = URL(string: thumbnailURLString) {
                                        SDWebImagePrefetcher.shared.prefetchURLs([thumbnailURL])
                                    }
                                    connections.append(User(dictionary: dictionary))
                                    print(connections)
                                    localPhones = phones
                                    self.delegate?.connections(updateDatasource: connections)
                                }
                            }
                        })

                    }
                }
            }
        }
        getContacts()
        /*
         do {
         try store.enumerateContacts(with: request) { contact, stop in
         connections.append(contact)
         }
         } catch {}
         */
        
        //removed value.stringValue after second $0
        //removed .map({$0.digits})
        //phoneNumbers = connections.compactMap({$0.phoneNumber})
        //localPhones = phoneNumbers
    }
    
}


