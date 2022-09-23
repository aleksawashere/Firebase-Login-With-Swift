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
        
    @Environment(\.editMode) var editButton
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()

    var body: some View {
        
        
        VStack(spacing:20){
            if logStatus{
                TaskHome()
            }
        }
        .overlay(content: {
            ZStack{
                    MoreOptionsView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y:taskModel.moreOptions ? (useFaceID ? 10 : -10) : (useFaceID ? 175 : 120))
                        .animation(.easeInOut(duration: 0.7), value: taskModel.moreOptions)
            }
            
        })
        
}

@ViewBuilder
func MoreOptionsView() -> some View{
    VStack(spacing:15){
        
        Button(action: {
            taskModel.moreOptions.toggle()
        }, label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.white)
                .padding()
                .background(.gray, in: Circle())
        })
        .padding()
        .padding()
        .shadow(color: .gray, radius: 15, x:0, y:0)
        .font(.system(size:30))
        
        VStack(spacing:15){
        Button{
            try? Auth.auth().signOut()
            logStatus = false
        } label:{
            Text("Izloguj se 🥹")
                .bold()
                .frame(width: 200, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
                .foregroundColor(.white)
            
            
        }
        .toolbar{
            EditButton()
                .padding(20)
        }
        
        if useFaceID{
            //Clearing FaceID
            Button(){
                useFaceID = false
                faceIDEmail = ""
                faceIDPassword = ""
            } label: {
                Text("Isključi FaceID 🩻")
                    .bold()
                    .frame(width: 200, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.linearGradient(colors:[.red,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            }
        }
        }
        .padding()
        .padding()
    }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
