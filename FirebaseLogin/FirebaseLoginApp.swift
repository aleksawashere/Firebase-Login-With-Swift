//
//  FirebaseLoginApp.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 25.6.22..
//

import SwiftUI
import Firebase


@main
struct FirebaseLoginApp: App {
    
    let persistenceController = PersistenceController.shared
    
    init(){
        FirebaseApp.configure()//na osnovu ove linije koda i plista koji je uvezen, ostvarili smo konekciju sa Firebase-om
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
