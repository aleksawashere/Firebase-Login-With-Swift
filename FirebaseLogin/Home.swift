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
    
    var body: some View {
        
        
        VStack(spacing:20){
            
            if logStatus{
                Text("Logged in")
                
                Button("Logout"){
                    try? Auth.auth().signOut()
                    logStatus = false
                }
            }
            else{
                Text("Came as Guest!")
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Home")
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
