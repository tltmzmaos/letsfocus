//
//  TimerView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/12/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI
import UserNotifications
import AudioToolbox
import AVFoundation
import CoreData


// MARK: - Timer View

struct TimerView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TimeSetting.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TimeSetting.newDate, ascending: false)]) var timeSetting: FetchedResults<TimeSetting>
    @FetchRequest(entity: Days.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Days.dayDate, ascending: false)]) var dayData: FetchedResults<Days>
    
    @State var totalDays = [String]()
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    
    @State var round = 1
    @State var start = false
    @State var to : CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isBreak = false
    @State var isAuto = false
    @State var isOn = false
    
    @State var goalTime = 1500
    @State var breakTime = 300
    @State var longBreak = 1500
    @State var startTimeForB: Date?
    @State var goalTimeInMin = 25
    @State var breakTimeInMin = 5
    @State var longBreakInMin = 25
    
    @State private var timeSettingSheet = false
    
    
    var body: some View{
        ZStack{
            VStack{
                
                Text("Pomodoro Timer").font(.largeTitle).bold().padding(.top)
                ZStack{
                    Circle().trim(from: 0, to: 1)
                        .stroke(Color(red: 255/255, green: 102/255, blue: 0/255).opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .square))
                        .frame(width: 300, height: 300).aspectRatio(contentMode: .fit)
                    
                    Circle().trim(from: 0, to: self.to)
                        .stroke(Color(red: 255/255, green: 102/255, blue: 0/255), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
                        .frame(width: 300, height: 300).aspectRatio(contentMode: .fit)
                        .rotationEffect(.init(degrees: -90))
                    
                    
                    VStack{
                        Text("Round \(self.round)")
                        if self.isBreak == false{
                            Text(self.secondsToMinutesSeconds(seconds: (self.goalTime-self.count)))
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                            
                            Image(systemName: "book")
                            Text("Study")
                            
                        }
                        if self.isBreak{
                            if round % 4 == 0{
                                Text(self.secondsToMinutesSeconds(seconds: (self.longBreak-self.count)))
                                    .font(.system(size: 50))
                                    .fontWeight(.bold)
                                
                                Image(systemName: "rosette")
                                Text("Long break")
                                
                                
                            }else{
                                Text(self.secondsToMinutesSeconds(seconds: (self.breakTime-self.count)))
                                    .font(.system(size: 50))
                                    .fontWeight(.bold)
                                
                                Image(systemName: "lightbulb.slash")
                                Text("Short break")
                                
                            }
                        }
                    }
                }.padding(.top)
                
                
                VStack{
                    
                    HStack{
                        Text("Auto Repeat").font(.system(size: 20)).bold()
                        Spacer()
                        Button(action:{
                            if !self.isAuto{
                                self.isOn.toggle()
                            }
                            self.isAuto.toggle()
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 15).fill(self.isAuto ? Color.green : Color.gray).frame(width: 60, height: 40, alignment: .center)
                                Text(self.isAuto ? "On" : "Off").foregroundColor(Color.white).bold()
                            }
                            .alert(isPresented: $isOn){
                                Alert(title: Text("Alert"), message: Text("The phone screen will be turned on during the auto repeat mode\nBe careful with the battery"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }.padding(.horizontal)
                
                    
                    
//                    Toggle(isOn: $isAuto){
//                        Text("Auto Repeat").font(.system(size: 20)).bold()
//                    }.padding([.top, .horizontal])
                                        
                    HStack{
                        Text("Time Setting").font(.system(size: 20)).bold()
                        Spacer()
                        Button(action: {
                            self.timeSettingSheet.toggle()
                        }){
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.red)
                                .aspectRatio(contentMode: .fit)
                        }
                    }.sheet(isPresented: $timeSettingSheet){
                        TimeSettingView(timeSettingSheet: self.$timeSettingSheet, goalTime: self.$goalTime, breakTime: self.$breakTime, longBreak: self.$longBreak, goalTimeInMin: self.$goalTimeInMin, breakTimeInMin: self.$breakTimeInMin, longBreakInMin: self.$longBreakInMin)
                            .environment(\.managedObjectContext, self.moc)
                    }.padding(.horizontal)
                    
                }
                
                // MARK:- Start Button
                HStack(spacing: 40){
                    Button(action: {
                        if self.count == self.goalTime && self.isBreak == false{
                            self.count = 0
                            withAnimation(.default){
                                self.to = 0
                            }
                        }else{
                            if Int(self.round)%4 == 0{
                                if self.count == self.longBreak && self.isBreak{
                                    self.count = 0
                                    withAnimation(.default){
                                        self.to = 0
                                    }
                                }
                                self.start.toggle()
                            }
                            else{
                                if self.count == self.breakTime && self.isBreak{
                                    self.count = 0
                                    withAnimation(.default){
                                        self.to = 0
                                    }
                                }
                                self.start.toggle()
                            }
                        }
                        
                    }) {
                        Image(systemName: self.start ? "pause.fill" : "play.fill").imageScale(.large).foregroundColor(Color.white)
                        .frame(width: 70, height: 70, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .padding(10)
                        .shadow(color: Color.gray, radius: 10)
                    }.padding(.horizontal)
                    
                    
                    // MARK:- Reset Button
                    Button(action: {
                        self.count = 0
                        withAnimation(.default){
                            self.to = 0
                        }
                    }) {
                        Image(systemName: "gobackward").imageScale(.large).foregroundColor(Color.white)
                        .frame(width: 70, height: 70, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .padding(10)
                        .shadow(color: Color.gray, radius: 10)
                    }
                }.padding(.vertical)
            }
            
        }
        // MARK:- Screen call functions, Stay in the screen
            
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
            }
        })
            .onReceive(self.time) { (_) in
                
                if self.isAuto{
                    UIApplication.shared.isIdleTimerDisabled = true
                    
                }else{
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                
                if self.start && self.isBreak == false{
                    if self.count < self.goalTime{
                        self.count += 1
                        withAnimation(.default){
                            self.to = CGFloat(self.count) / CGFloat(self.goalTime)
                        }
                    }
                    else{
                        if self.isAuto == false{
                            self.start.toggle()
                        }
                        //self.Notify(timeLeft: self.goalTime - self.count)
                        //self.Notify(timeLeft: 1)
                        AudioServicesPlaySystemSound(1007)
                        self.isBreak.toggle()
                        self.count = 0
                        self.round += 1
                        
                        // MARK:- Save round data
                        let newRound = Rounds(context: self.moc)
                        newRound.roundDate = Date()
                        try? self.moc.save()
                        
                    }
                }
                if self.start && self.isBreak{
                    if Int(self.round)%4 == 0{
                        if self.count < self.longBreak{
                            self.count += 1
                            withAnimation(.default){
                                self.to = CGFloat(self.count) / CGFloat(self.longBreak)
                            }
                        }else{
                            if self.isAuto == false{
                                self.start.toggle()
                            }
                            //self.Notify(timeLeft: 1)
                            AudioServicesPlaySystemSound(1007)
                            self.isBreak.toggle()
                            self.count = 0
                        }
                    }else{
                        if self.count < self.breakTime{
                            self.count += 1
                            withAnimation(.default){
                                self.to = CGFloat(self.count) / CGFloat(self.breakTime)
                            }
                        }else{
                            if self.isAuto == false{
                                self.start.toggle()
                            }
                            //self.Notify(timeLeft: 1)
                            AudioServicesPlaySystemSound(1007)
                            self.isBreak.toggle()
                            self.count = 0
                        }
                    }
                }
                
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            // MARK:- Time setting changes when this tap called
            .onAppear{
                
                
                
                // MARK:- adds new day when app launches

                for i in self.dayData{
                    if !self.totalDays.contains(self.dateFormatter.string(from: i.dayDate!)){
                        self.totalDays.append(self.dateFormatter.string(from: i.dayDate!))
                    }
                }

                if !self.totalDays.contains(self.dateFormatter.string(from: Date())){
                    let newDay = Days(context: self.moc)
                    newDay.dayDate = Date()
                    try? self.moc.save()
                }

                
                if self.timeSetting.count > 0{
                
                    self.goalTime = Int(self.timeSetting[0].studyTime)
                    self.breakTime = Int(self.timeSetting[0].shortBreak)
                    self.longBreak = Int(self.timeSetting[0].longBreak)
                    
                    self.goalTimeInMin = self.goalTime/60
                    self.breakTimeInMin = self.breakTime/60
                    self.longBreakInMin = self.longBreak/60
                    
                }
        }
                
        
            
            // MARK:-  When user leaves App
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)){_ in
                self.startTimeForB = Date()
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SCM"])
                
                if self.start && self.isBreak == false{
                    self.Notify(timeLeft: self.goalTime-self.count)
                }
                if self.start && self.isBreak{
                    if self.round%4 == 0{
                        self.Notify(timeLeft: self.longBreak-self.count)
                    }else{
                        self.Notify(timeLeft: self.breakTime-self.count)
                    }
                }
        }
            
            // MARK:- When user comes back to App
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){_ in
                let comeBackTime = Date()
                let seconds = Int(comeBackTime.timeIntervalSince(self.startTimeForB!))
                
                if self.start && self.isBreak == false{
                    if self.count+seconds < self.goalTime{
                        self.count += seconds
                        withAnimation(.default){
                            self.to = CGFloat(self.count) / CGFloat(self.goalTime)
                        }
                    }
                    else{
                        if self.isAuto == false{
                            self.start.toggle()
                        }
                        self.Notify(timeLeft: 1)
                        self.round += 1
                        self.isBreak.toggle()
                        self.count = 0
                        self.to = 1

                        let newRound = Rounds(context: self.moc)
                        newRound.roundDate = Date()
                        try? self.moc.save()
                    }
                }
                if self.start && self.isBreak{
                    if Int(self.round)%4 == 0{
                        if self.count+seconds < self.longBreak{
                            self.count += seconds
                            withAnimation(.default){
                                self.to = CGFloat(self.count) / CGFloat(self.longBreak)
                            }
                        }else{
                            if self.isAuto == false{
                                self.start.toggle()
                            }
                            self.Notify(timeLeft: 1)
                            self.isBreak.toggle()
                            self.count = 0
                            self.to = 1
                        }
                    }else{
                        if self.count+seconds < self.breakTime{
                            self.count += seconds
                            withAnimation(.default){
                                self.to = CGFloat(self.count) / CGFloat(self.breakTime)
                            }
                        }else{
                            if self.isAuto == false{
                                self.start.toggle()
                            }
                            self.Notify(timeLeft: 1)
                            self.isBreak.toggle()
                            self.count = 0
                            self.to = 1
                        }
                    }
                }
        }
    }
    
    // MARK:- Helper functions
    func Notify(timeLeft: Int){
        let content = UNMutableNotificationContent()
        content.title = "Let's focus"
        content.body = "Completed"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeLeft), repeats: false)
        let req = UNNotificationRequest(identifier: "SCM", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> String {
        return String(format: "%02d:%02d:%02d", seconds/3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

