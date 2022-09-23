//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 25.6.22..
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    //Log status
    @AppStorage("log_status") var logStatus: Bool = false

    var body: some View{
        
        NavigationView{
            if logStatus{
                Home()
            }
            else{
                LoginPage()
                .navigationBarHidden(true)
            }
        }.accentColor(.black)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
