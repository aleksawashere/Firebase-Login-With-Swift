//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 25.6.22..
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
            content
    }
    
    var content: some View{
        ZStack{
            Color.white
            
            RoundedRectangle(cornerRadius: 30,style: .continuous).foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 500)
                .rotationEffect(.degrees(180))
                .offset(x:-220, y: -395)
            
            Circle()
                .foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 400, height: 600)
                .offset(y:100)
            
            Circle().foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 400, height: 600)
                .offset(y:550)
            
            HStack{
               
                VStack{
                    HStack{
                        Image("TickIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("TickYourWork")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Rectangle()
                        .frame(width: 170, height: 1)
                       .foregroundColor(.white)
                      .offset(y:-10)
                }
                
            }
            .padding().padding().padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            

            VStack(spacing:20){
                VStack(spacing:20){

                
                    
                Text("Welcome")
                    .foregroundColor(Color.white)
                    .font(.system(size:55, weight: .bold, design: .rounded))
                    .offset(x:-55,y:-150)
                Text("back!")
                    .foregroundColor(Color.white)
                    .font(.system(size:55, weight: .bold, design: .rounded))
                    .offset(x:-98,y:-175)
                }.offset(y:50)
                
                VStack(spacing:20){
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty){
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 26)
                        .stroke(.white,lineWidth: 2)
                    )
            
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty){
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 26)
                        .stroke(.white,lineWidth: 2)
                    )
                
                    Button{
                        register()
                    } label:{
                        Text("Sign up")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(.white)
                            )
                            .foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    
                    Button{
                        login()
                    } label:{
                        Text("Already have an account?")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                
                }
                .offset(y:20)
                    
            }
            .frame(width: 250)
            .onAppear{
                Auth.auth().addStateDidChangeListener{auth, user in
                    if user != nil{
                        userIsLoggedIn.toggle()
                    }
                }
            }
            
        }
        .ignoresSafeArea()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
            
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
            
        }
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
