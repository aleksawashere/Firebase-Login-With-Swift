//
//  BarGraph.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 28.9.22..
//

import SwiftUI

struct BarGraph: View {
    var stats: [Stats]
    
    //Gesture Properties
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = 0
    
    //Current stats to highlight while dragging
    @State var currentStatsID: String = ""
    
    var body: some View {
        
        HStack(spacing:10){
            
            ForEach(stats){ stat in
                CardView(stats: stat)
            }
            
        }
        .frame(height:150)
        .animation(.easeOut, value: isDragging)
        //Gesture
        .gesture(
            DragGesture()
                .updating($isDragging, body: {_, out, _ in
                    out = true
                })
                .onChanged({value in
                    //Only updating if dragging
                    offset = isDragging ? value.location.x : 0
                    
                    //Dragging space removing the padding added to the view
                    //total padding = 60
                    // 2 * 15 horizontal
                    let draggingSpace = UIScreen.main.bounds.width - 60
                    
                    //Each block
                    let eachBlock = draggingSpace / CGFloat(stats.count)
                    
                    //getting index
                    let temp = Int(offset / eachBlock)
                    
                    //safe wrapping index
                    let index = max(min(temp,stats.count-1),0)
                    
                    //updating ID
                    self.currentStatsID = stats[index].id
                })
                .onEnded({value in
                    withAnimation{
                        offset = .zero
                        currentStatsID = ""
                    }
                })
        )
    }
    
    @ViewBuilder
    func CardView(stats: Stats)->some View{
        VStack(spacing:20){
            GeometryReader{proxy in
                
                let size = proxy.size
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(stats.color)
                    .opacity(isDragging ? (currentStatsID == stats.id ? 1 : 0.35) : 1)
                    .frame(height: (stats.min / getMax()) * (size.height))
                    .overlay(
                        Text("\(Int(stats.min))")
                            .font(.callout)
                            .foregroundColor(.white)
                            .opacity(isDragging && currentStatsID == stats.id ? 1 : 0)
                            .offset(y:-30),alignment: .top
                    )
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            Text(stats.day)
                .font(.callout)
                .foregroundColor(currentStatsID == stats.id ? stats.color : .white)
        }
    }
    
    // to get Graph heigth...
    // getting max in the stats
    
    func getMax()->CGFloat{
        let max = stats.max{first, second in
            return second.min > first.min
        }
        return max?.min ?? 0
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        NewTimer()
            .environmentObject(TimerModel())
    }
}

