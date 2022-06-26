//
//  DynamicFilterView.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 26.6.22..
//

import SwiftUI
import CoreData

struct DynamicFilterView<Content: View,T>: View where T: NSManagedObject {
    
    //MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    //MARK: Building Custom ForEach which will give CoreData object to build View
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T)->Content){
        
        //MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        //Kljuc za filtriranje po datumu u aplikaciji
        let filterKey = "taskDate" //element u objektu Task koji nam se nalazi u CoreData
        
        // Ovo ce povlaciti zadatke izmedju danas i sutra, a to je zapravo 24h!
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) =< %@", argumentArray: [today, tommorow])
        
        //Initializing Request with NSPredicate and adding sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Zadatak.taskDate, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group{
            if request.isEmpty{
                Text("Uživaj u ovom danu!☀️")
                    .font(.system(size:16))
                    .fontWeight(.light)
                Text("Nema zadataka za tebe!🎉")
                    .font(.system(size:16))
                    .fontWeight(.light)
            }
            else{
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
