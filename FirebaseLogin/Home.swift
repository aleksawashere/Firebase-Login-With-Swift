//
//  Home.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 25.6.22..
//

import SwiftUI
import Firebase

struct Home: View {
    
    //Log status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //MARK: FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var faceIDEmail: String = ""
    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    var body: some View {
        
        
        VStack(spacing:20){
            
            if logStatus{
                
                TaskHome()
                
                Text("Logged in")
                
                Button("Logout"){
                    try? Auth.auth().signOut()
                    logStatus = false
                }
            }
            else{
                Text("Came as Guest!")
            }
            
            if useFaceID{
                //Clearing FaceID
                Button("Disable FaceID login"){
                    useFaceID = false
                    faceIDEmail = ""
                    faceIDPassword = ""
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
