//
//  LoginPage.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 25.6.22..
//

import SwiftUI
import Firebase

struct LoginPage: View {
    @StateObject var loginModel: LoginViewModel = LoginViewModel()

    //MARK: FaceID Properties
    @State var useFaceID: Bool = false
    
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

                
                    
                Text("Dobrodošli u aplikaciju! ")
                    .foregroundColor(Color.white)
                    .font(.system(size:65, weight: .bold, design: .rounded))
                    .offset(y:-130)
                    .multilineTextAlignment(.center)
                }.frame(width: 400)
                
                SwiftUI.VStack(spacing:20){
                    TextField("E-mail", text: $loginModel.email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: loginModel.email.isEmpty){
                        Text("E-mail")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 26)
                        .stroke(.white,lineWidth: 2)
                    )
                    .textInputAutocapitalization(.never)
            
                
                    SecureField("Šifra", text: $loginModel.password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: loginModel.password.isEmpty){
                        Text("Šifra")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 26)
                        .stroke(.white,lineWidth: 2)
                    )
                    .textInputAutocapitalization(.never)

                    
                    //MARK: User prompt to ask to store Login using FaceID on next time
                    if loginModel.getBioMetricStatus(){
                        SwiftUI.Group{
                            if loginModel.useFaceID{
                                Button{
                                    //MARK: Do FaceID Action
                                    Task{
                                        do{
                                            try await loginModel.authenticateUser()
                                        }
                                        catch{
                                            loginModel.errorMsg = error.localizedDescription
                                            loginModel.showError.toggle()
                                        }
                                    }
                                }label:{
                                    VStack(alignment: .leading, spacing: 10){
                                        Label{
                                            Text("Use FaceID to login into previous account")
                                        } icon:{
                                            Image(systemName: "faceid")
                                        }
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(width: 450)
                                        
                                        Text("Note: You can turn off it in settings")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .frame(width: 450)
                                    }
                                }
                                
                            }
                            else{
                                Toggle(isOn: $useFaceID){
                                    Text("Use FaceID to Login")
                                        .foregroundColor(.white)
                                }
                                
                            }
                        }
                    }

                
                    Button{
                        
                        SwiftUI.Task{
                            do{
                                try await loginModel.loginUser(useFaceID: useFaceID)
                            }
                            catch{
                                loginModel.errorMsg = error.localizedDescription
                                loginModel.showError.toggle()
                            }
                        }
                        
                    } label:{
                        Text("Uloguj se 🤗")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(.white)
                            )
                            .foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    
                    NavigationLink{
                        //MARK: Going to signup
                        SignUpPage()
                        
                    } label:{
                        Text("Nemaš nalog? Kreiraj ga!")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink{
                        //MARK: Going to application without login
                        TaskHomeGuest()
                            .frame(width: 400, height: 710)
                            .navigationTitle("Režim bez naloga")
                    } label:{
                        Text("Preskoči to sada")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                
                }
                .offset(y:20)
                    
            }
            .frame(width: 250)
            
            .alert(loginModel.errorMsg, isPresented: $loginModel.showError){
                
            }
            
        }
        
        .ignoresSafeArea()
        }
    }

    struct LoginPage_Previews: PreviewProvider {
        static var previews: some View {
            LoginPage()
        }
    }

    


