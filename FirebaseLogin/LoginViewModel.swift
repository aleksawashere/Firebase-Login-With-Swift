//
//  LoginViewModel.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI
import Firebase
import LocalAuthentication

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    //MARK: FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var faceIDEmail: String = ""
    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    //Log status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //MARK: Error
    @Published var showError: Bool = false
    @Published var errorMsg: String = ""
    
    
    //MARK: Firebase login
    func loginUser(useFaceID: Bool, email:String = "", password: String = "")async throws{
        print(email)
        print(password)
        let _ = try await Auth.auth().signIn(withEmail: email != "" ? email : self.email, password: password != "" ? password : self.password)
            if useFaceID{
                self.useFaceID = useFaceID
                
                //MARK: Storing for future FaceID login
                faceIDEmail = email
                faceIDPassword = password

            }

            logStatus = true

        }
    
    //MARK: FaceID Usage
    
    func getBioMetricStatus()->Bool{
        
        let scanner = LAContext()
        return scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
        
    }
    
    //MARK: FaceID Login
    
    func authenticateUser()async throws{
        
        let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login Into App")
        
        if status{
            try await loginUser(useFaceID: useFaceID, email: self.faceIDEmail, password: self.faceIDPassword)
        }
        
    }
}

