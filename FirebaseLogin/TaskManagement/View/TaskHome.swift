//
//  TaskHome.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI

struct TaskHome: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    //MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    //MARK: Edit Button Context
    @Environment(\.editMode) var editButton

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){

            //MARK: Lazy stack with pinned header
            LazyVStack(spacing:15, pinnedViews: [.sectionHeaders]) {
                
                
                Section{
                //MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack(spacing:10){
                            ForEach(taskModel.currentWeek, id: \.self){ day in
                                
                                VStack(spacing:10){
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size:14))
                                        .fontWeight(.semibold)

                                    
                                    //EEE will return day in as MON, TUE,...
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size:14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width:8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                //MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                //MARK: Capsule shape
                                .frame(width: 45, height: 90)
                                .background(
                                
                                    ZStack{
                                        //MARK: Animation when we change weekday
                                        if taskModel.isToday(date: day){
                                            Capsule()
                                                .fill(.orange)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                        
                                    }
                                    
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        taskModel.currentDay = day
                                    }
                                }
                                
                                
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                    TasksView()
                    
                } header: {
                    HeaderView()
                        
                }
                
                
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        
        //MARK: Add Button
        .overlay(
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    
                    .padding()
                    .background(Color("OrangeTick"), in: Circle())
            })
            .padding()
            .padding()
            .font(.system(size:30))

            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask){
            
            //Clearing edit data
            taskModel.editTask = nil
            
        } content:{
            NewTask()
                .environmentObject(taskModel)
        }
    }
    
    //MARK: Tasks View
    func TasksView()->some View{
        LazyVStack(spacing:30){
            
            //Converting object as Our Task Model
            DynamicFilterView(dateToFilter: taskModel.currentDay){ (object: Zadatak) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
        
        
    }
    
    
    //MARK: Task Card View
    func TaskCardView(task: Zadatak)->some View{
        
        //MARK: Since CoreData Values will give optional data
        HStack(alignment: editButton?.wrappedValue == .active ? .center: .top, spacing:15){
            
            //Ako je edit mode ukljucen, onda prikazujemo dugme za brisanje
            
            if editButton?.wrappedValue == .active{
                
                // Edit Button for Current and Future tasks
                VStack(spacing:10){
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        }label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Button {
                        //MARK: Deleting task
                        context.delete(task)
                        
                        //Cuvanje
                        try? context.save()
                    }label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                
            }
            else{
                VStack(spacing:10){
                    Circle()
                        .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompleted ? Color("GreenTick") : Color("OrangeTick")) : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                        Circle()
                            .stroke((task.isCompleted ? Color("GreenTick") : Color("OrangeTick")),lineWidth: 1)
                            .padding(-3)
                        )
                        .scaleEffect(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0.8)
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width:3)
                }
            }
            
            VStack{
                HStack(alignment: .top, spacing: 10){
                    
                    VStack(alignment: .leading, spacing: 12){
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date:.omitted, time:.shortened) ?? "")
                    
                                        
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()){
                    //MARK: Team Members
                    HStack(spacing:12){
                        
                        
                        //MARK: Check Button
                        if !task.isCompleted{
                            Button{
                                //Azuriranje statusa izvrsenosti zadatka
                                task.isCompleted = true
                                
                                //Cuvanje
                                try? context.save()
                                
                            } label:{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
                                    .padding(10)
                                    .background(.white, in:RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Završeno!" : "Čekiraj zadatak ako je završen")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(.white)
                            .hLeading()
                        
                    }
                    .padding(.top)
                }

                
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 20 : 5)
            .hLeading()
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 1)
            .background(
                Color("OrangeTick")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            
            )
        }
        .hLeading()
    }
    
    
    
    
    //MARK: Header
    func HeaderView()->some View{
        
        HStack(spacing:10){
            
            VStack(alignment: .leading, spacing:10){
                
                Text(Date().formatted(date: .abbreviated, time:.omitted))
                    .foregroundColor(.gray)

                Text("Danas")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button{
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .padding(15)
                    .padding(.top)
            }
            
            //MARK: Edit button
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
 
}

struct TaskHome_Previews: PreviewProvider {
    static var previews: some View {
        TaskHome()
            .previewInterfaceOrientation(.portrait)
    }
}

//MARK: UI Pomocne dizajn funkcije
//Ove ekstenzije ce izbeci koriscenje Spacer() i .frame(), a samim tim ce i kod biti dosta citljiviji

extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .zero, alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .zero, alignment: .center)
    }
    
    
    //MARK: Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}
