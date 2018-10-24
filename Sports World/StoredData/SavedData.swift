//
//  SavedData.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/9/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation

public class SavedData {
    //GUARDA EN USER DEFAULTS LOS DATOS MAS USADOS DENTRO DE LA APP.
    class func setTheLongitude(double:Double) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(double, forKey:"setTheLongitude")
        userDefaults.synchronize()
    }
    
    class func getTheLongitude() -> Double {
        let userDefaults = UserDefaults.standard
        if let longitude = userDefaults.object(forKey: "setTheLongitude") as! Double? {
            return longitude
            
        } else {
            return 0.0
        }
    }

    class func setTheLatitude(double:Double) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(double, forKey:"setTheLatitude")
        userDefaults.synchronize()
    }
    
    class func getTheLatitude() -> Double {
        let userDefaults = UserDefaults.standard
        if let latitude = userDefaults.object(forKey: "setTheLatitude") as! Double? {
            return latitude
            
        } else {
            return 0.0
        }
    }
    
    class func setTheUserId(userId:Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userId, forKey:"userId")
        userDefaults.synchronize()
    }
    
    class func getTheUserId() -> Int {
        let userDefaults = UserDefaults.standard
        if let userId = userDefaults.object(forKey: "userId") as! Int? {
            return userId
            
        } else {
            return 0
        }
    }
    class func setTheMemberNumber(memberNumber:Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(memberNumber, forKey:"memberNumber")
        userDefaults.synchronize()
    }
    
    class func getTheMemberNumber() -> Int {
        let userDefaults = UserDefaults.standard
        if let memberNumber = userDefaults.object(forKey: "memberNumber") as! Int? {
            return memberNumber
            
        } else {
            return 0
        }
    }
    class func settokenConekta(tokenConekta: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(tokenConekta, forKey:"tokenConekta")
        userDefaults.synchronize()
    }
    
    class func gettokenConekta() -> String {
        let userDefaults = UserDefaults.standard
        if let tokenConekta = userDefaults.object(forKey: "tokenConekta") as! String? {
            return tokenConekta
            
        } else {
            return ""
        }
    }
    
    class func seTMemUnicId(memUnicId: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(memUnicId, forKey:"memUnicId")
        userDefaults.synchronize()
    }
    
    class func getMemUnicId() -> Int {
        let userDefaults = UserDefaults.standard
        if let memUnicId = userDefaults.object(forKey: "memUnicId") as! Int? {
            return memUnicId
            
        } else {
            return 0
        }
    }
    class func setSecretKey(secretKey: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(secretKey, forKey:"secretKey")
        userDefaults.synchronize()
    }
    
    class func getSecretKey() -> String {
        let userDefaults = UserDefaults.standard
        if let secretKey = userDefaults.object(forKey: "secretKey") as! String? {
            return secretKey
            
        } else {
            return ""
        }
    }
    class func setTokenDay(tokenDay: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(tokenDay, forKey:"tokenDay")
        userDefaults.synchronize()
    }
    
    class func getTokenDay() -> String {
        let userDefaults = UserDefaults.standard
        if let tokenDay = userDefaults.object(forKey: "tokenDay") as! String? {
            return tokenDay
            
        } else {
            return ""
        }
    }
    class func setTheName(theName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(theName, forKey:"theName")
        userDefaults.synchronize()
    }
    
    class func getTheName() -> String {
        let userDefaults = UserDefaults.standard
        if let theName = userDefaults.object(forKey: "theName") as! String? {
            return theName
            
        } else {
            return ""
        }
    }
    class func setTheProfilePic(profilePic: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(profilePic, forKey:"profilePic")
        userDefaults.synchronize()
    }
    
    class func getTheProfilePic() -> String {
        let userDefaults = UserDefaults.standard
        if let profilePic = userDefaults.object(forKey: "profilePic") as! String? {
            return profilePic
            
        } else {
            return ""
        }
    }
    
    class func setTheEmail(email: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(email, forKey:"email")
        userDefaults.synchronize()
    }
    
    class func getTheEmail() -> String {
        let userDefaults = UserDefaults.standard
        if let email = userDefaults.object(forKey: "email") as! String? {
            return email
            
        } else {
            return ""
        }
    }
    class func setTheClub(club: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(club, forKey:"club")
        userDefaults.synchronize()
    }
    
    class func getTheClub() -> String {
        let userDefaults = UserDefaults.standard
        if let club = userDefaults.object(forKey: "club") as! String? {
            return club
            
        } else {
            return ""
        }
    }
    
    class func setMemberType(memberType: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(memberType, forKey:"memberType")
        userDefaults.synchronize()
    }
    
    class func gettMemberType() -> String {
        let userDefaults = UserDefaults.standard
        if let memberType = userDefaults.object(forKey: "memberType") as! String? {
            return memberType
            
        } else {
            return ""
        }
    }
    
    class func setTheMantaniance(mantaniance: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(mantaniance, forKey:"mantaniance")
        userDefaults.synchronize()
    }
    
    class func getTheMantaniance() -> String {
        let userDefaults = UserDefaults.standard
        if let mantaniance = userDefaults.object(forKey: "mantaniance") as! String? {
            return mantaniance
            
        } else {
            return ""
        }
    }
    class func setTheHeight(height:Double) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(height, forKey:"height")
        userDefaults.synchronize()
    }
    
    class func getTheHeight() -> Double {
        let userDefaults = UserDefaults.standard
        if let height = userDefaults.object(forKey: "height") as! Double? {
            return height
            
        } else {
            return 0.0
        }
    }
    class func setTheWeight(weight:Double) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(weight, forKey:"weight")
        userDefaults.synchronize()
    }
    
    class func getTheWeight() -> Double {
        let userDefaults = UserDefaults.standard
        if let weight = userDefaults.object(forKey: "weight") as! Double? {
            return weight
            
        } else {
            return 0.0
        }
    }
    class func setTheAge(age:Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(age, forKey:"age")
        userDefaults.synchronize()
    }
    
    class func getTheAge() -> Int {
        let userDefaults = UserDefaults.standard
        if let age = userDefaults.object(forKey: "age") as! Int? {
            return age
            
        } else {
            return 0
        }
    }
    
    class func setInBody(isInBody:Bool){
        let userDefaults = UserDefaults.standard
        userDefaults.set(isInBody, forKey:"inBody")
        userDefaults.synchronize()
    }
    
    class func getInBody() -> Bool {
        let userDefaults = UserDefaults.standard
        if let inBody = userDefaults.object(forKey: "inBody") as! Bool? {
            return inBody
        } else {
            return false
        }
    }
    
}
