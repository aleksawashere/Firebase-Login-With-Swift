//
//  SignUpPage.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 29.6.22..
//

import SwiftUI
import Firebase

struct SignUpPage: View {
    @StateObject var loginModel: LoginViewModel = LoginViewModel()
    
    
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

                
                    
                Text("Napravi nalog! ")
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


                
                    Button{
                        
                        SwiftUI.Task{
                            do{
                                try await loginModel.signUpUser()
                            }
                            catch{
                                loginModel.errorMsg = error.localizedDescription
                                loginModel.showError.toggle()
                            }
                        }
                        
                    } label:{
                        Text("Napravi nalog 🤗")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(.white)
                            )
                            .foregroundStyle(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
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

    struct SignUpPage_Previews: PreviewProvider {
        static var previews: some View {
            SignUpPage()
        }
    }
