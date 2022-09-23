//
//  TaskViewModel.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI

class TaskViewModel: ObservableObject{
    
    //MARK: Current Week Days
    
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    //Pamcenjem ove varijable, znacemo na kom danu se nalazimo kada korisnik klikne
    @Published var currentDay: Date = Date()
    
    //MARK: Filtering todays tasks
    
    @Published var filteredTasks: [Zadatak]?
    
    //MARK: New Task View
    @Published var addNewTask: Bool = false
    
    //MARK: New Timer View
    @Published var addNewTimer: Bool = false
    
    //MARK: More Options View
    @Published var moreOptions: Bool = false
    
    //MARK: Edit Data
    @Published var editTask: Zadatak?
    
    //MARK: Initializing
    init(){
        fetchCurrentWeek()
    }
    
   
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
           if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    //MARK: Extracting Date
    
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: Checking if current Date is Today
    //Moramo proveriti svakog puta koji dan je Danas, kako bi se na taj element prvo "zakacili"
    
    func isToday(date: Date)->Bool{
        let calender = Calendar.current
        return calender.isDate(currentDay, inSameDayAs: date)
    }
    
    //MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date)->Bool{
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour && isToday)
    }
}
