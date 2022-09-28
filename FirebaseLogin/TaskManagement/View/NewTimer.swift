//
//  NewTimer.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 23.9.22..
//

import SwiftUI

struct NewTimer: View {
    
    @EnvironmentObject var timerModel: TimerModel
    
    var body: some View {
        VStack{
            
            Text("Vreme fokusiranosti")
                .font(.title2.bold())
            
            GeometryReader{proxy in
                VStack(spacing:15){
                    
                    //MARK: Timer Ring
                    ZStack{
                        
                        Circle()
                            .fill(.black.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from:0, to:timerModel.progress)
                            .stroke(.black.opacity(0.03),lineWidth: 80)
                            
                        
                        //MARK: Shadow
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color("Purple"),lineWidth: 5)
                            .blur(radius: 10)
                            .padding(-4)
                        
                        Circle()
                            .fill(Color("BG"))
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color("Purple").opacity(0.7),lineWidth: 10)
                        
                        //MARK: Knob
                        
                        GeometryReader{proxy in
                            let size = proxy.size
                            Circle()
                                .fill(Color("Purple"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(Color(.orange))
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                            //MARK: x axis is used because frame is rotated
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                        }
                        
                        Text(timerModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: timerModel.progress)
                        
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: timerModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button{
                        if timerModel.isStarted{
                            timerModel.stopTimer()
                            //MARK: Canceling all notifications!
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                        else{
                            timerModel.addNewTimer = true
                        }
                    } label:{
                        Image(systemName: !timerModel.isStarted ? "timer" : "stop.fill")
                            
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background{
                                Circle()
                                    .fill(Color("Purple"))
                            }
                            .shadow(color: Color("Purple"), radius: 8, x:0, y:0)
                            .font(.largeTitle.bold())
                            
                    }
                    
                    Button{
                        timerModel.showStats.toggle()
                    } label: {
                        Text("Statistika 📊")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color("Purple"))
                            )
                            .foregroundColor(.white)
                    }
                    
                    
                }
                
                
            }
            
        }
        .padding()
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack{
                Color.black
                    .opacity(timerModel.addNewTimer ? 0.2 : 0)
                    .onTapGesture {
                        //Reseting values when dismissing
                        timerModel.hour = 0
                        timerModel.minutes = 0
                        timerModel.seconds = 0

                        timerModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y:timerModel.addNewTimer ? 20 : 250)
            }
            .animation(.easeInOut, value: timerModel.addNewTimer)
            
        })
        .preferredColorScheme(.light)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){
            _ in
            if timerModel.isStarted{
                timerModel.updateTimer()
            }
        }
        .alert("Tajmer fokusiranog vremena je završen. Želite da pokrenete ponovo tajmer? ⏱", isPresented: $timerModel.isFinished) {
            Button("Pokreni novi", role: .cancel){
                timerModel.stopTimer()
                timerModel.addNewTimer = true
            }
            Button("Zatvori", role: .destructive){
                timerModel.stopTimer()
            }
        }
        
        .overlay(content: {
            ZStack{
                Color.black
                    .opacity(timerModel.showStats ? 0.5 : 0)
                    .onTapGesture {
                        timerModel.showStats = false
                    }
                    
                
                StatsView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y:timerModel.showStats ? 10 : 600)
            }
            .animation(.easeInOut, value: timerModel.showStats)
            .ignoresSafeArea()
            
        })
        
    }
    
    
    //MARK: New Timer Bottom Sheet
    @ViewBuilder
    func NewTimerView() -> some View{
        VStack(spacing: 15){
            Text("Pokreni novi tajmer")
                .font(.title2.bold())
                .padding(.top, 10)
            HStack(spacing: 15){
                Text("\(timerModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.black.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "hr"){ value in
                            timerModel.hour = value
                        }
                    }
                        
                Text("\(timerModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.black.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "min"){ value in
                            timerModel.minutes = value
                        }
                    }
                        
                Text("\(timerModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.black.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "sec"){ value in
                            timerModel.seconds = value
                        }
                    }
                    
                    }
            .padding(.top, 20)
            
            Button{
                timerModel.startTimer()
            } label: {
                Text("Sačuvaj")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 120)
                    .background{
                        Capsule()
                            .fill(Color("Purple"))
                    }
            }
            .disabled(timerModel.seconds == 0)
            .opacity(timerModel.seconds == 0 ? 0.5 : 1)
            
        }
        
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
    }
    
    //MARK: Reusable context menu options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int,hint: String,onClick: @escaping (Int)->())->some View{
        
        ForEach(0...maxValue,id: \.self){value in
            Button("\(value) \(hint)"){
                onClick(value)
            }
        }
    }
    
    //MARK: Stats Bottom Sheet
    @ViewBuilder
    func StatsView() -> some View{
        VStack(spacing:0){
            HStack{
                VStack(alignment: .center, spacing: 0){
                    Text("Statistika fokusiranog vremena")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        
                    
                    Label{
                        Image(systemName: "clock.arrow.circlepath")
                    }icon: {
                        Text("Poslednjih 7 dana")
                    }
                    .font(.callout)
                    .foregroundColor(.white)
                }
                
                
                
            }
            
            HStack{
                Text("380 min ukupno")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                
                Button{
                    
                }label: {
                    Image(systemName: "square.and.arrow.up").font(.title2.bold())
                        .foregroundColor(Color("Purple"))
                    Text("Podeli prijateljima")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                }
                .padding(.horizontal,10)
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color("BG"))
                )
                
            }
            .padding(.vertical,20)
            
            // Bar Graph With Gestures...
            
            BarGraph(stats: weekStats)
                .padding(.top,25)
            
            
        }
        .padding(35)
        .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Purple"))
        )
        .padding(.vertical, 20)
        .padding()
    }
    
}



struct NewTimer_Previews: PreviewProvider {
    static var previews: some View {
        NewTimer()
            .environmentObject(TimerModel())
    }
}
