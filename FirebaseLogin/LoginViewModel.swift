//
//  LoginViewModel.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI
import Firebase

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
    func loginUser(useFaceID: Bool)async throws{
        print(email)
        print(password)
        let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            if useFaceID{
                self.useFaceID = useFaceID
                
                //MARK: Storing for future FaceID login
                faceIDEmail = email
                faceIDPassword = password

            }

            logStatus = true

        }
}

