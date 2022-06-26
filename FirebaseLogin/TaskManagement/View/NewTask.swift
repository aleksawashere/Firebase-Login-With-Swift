//
//  NewTask.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    
    //MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    
    //MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel
    

    var body: some View {

        NavigationView{
            List{
                Section{
                    TextField("Idi na posao😓", text: $taskTitle)
                } header: {
                    Text("Naslov zadatka")
                }
                
                Section{
                    TextField("Ponesi laptop i kafu!☕️", text: $taskDescription)
                } header: {
                    Text("Opis zadatka")
                }
                
                //Disabling Date for Edit Mode
                if taskModel.editTask == nil {
                    Section{
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Datum zadatka")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Dodaj novi zadatak")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: Disabling Dismiss on Swipe
            .interactiveDismissDisabled()
            //MARK: Action Buttons
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sačuvaj"){
                        if let task = taskModel.editTask{
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        }
                        else{
                            let task = Zadatak(context: context)//komunikacija sa objektom u CoreData
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                        }
                        
                        //Cuvanje podataka
                        
                        try? context.save()
                        
                        //Gasenje prozora
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Odustani"){
                        dismiss()
                    }
                }
            }
            
            //Loading Task data if we come from Edit
            .onAppear(){
                if let task = taskModel.editTask{
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                }
            }
        }

    }
}

