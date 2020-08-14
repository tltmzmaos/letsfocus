//
//  TimeSettingView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/22/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI
import CoreData
import Combine


struct TimeSettingView: View{
    @ObservedObject var sv1: DRBCircularSliderData = DRBCircularSliderData(size: 200.0, stroke: 10.0, indicatorColor: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), handleColor: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), startAngle: 10.0, endAngle: 300.0, minValue: 10.0, maxValue: 300.0)
    
    @ObservedObject var sv2: DRBCircularSliderData = DRBCircularSliderData(size: 150.0, stroke: 10.0, indicatorColor: Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), handleColor: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), startAngle: 1.0, endAngle: 180.0, minValue: 1.0, maxValue: 30.0)
    
    @ObservedObject var sv3: DRBCircularSliderData = DRBCircularSliderData(size: 150.0, stroke: 10.0, indicatorColor: Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), handleColor: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), startAngle: 1.0, endAngle: 180.0, minValue: 1.0, maxValue: 60.0)
    
    @Environment(\.managedObjectContext) var moc
    
    @Binding var timeSettingSheet: Bool
    @Binding var goalTime: Int
    @Binding var breakTime: Int
    @Binding var longBreak: Int
    
    @Binding var goalTimeInMin: Int
    @Binding var breakTimeInMin: Int
    @Binding var longBreakInMin: Int
    
    @State var tempGoalTime = 0.0
    @State var tempBreakTime = 0.0
    @State var tempLongBreak = 0.0
    
        
    var body: some View{
        NavigationView{
            VStack{
                
                VStack{
                    ZStack{
                        DRBCircularSlider(data: sv1)
                        VStack{
                            Text("Study Time").font(.headline)
                            Text("\(Int(self.sv1.value))").font(.largeTitle)
                        }
                    }
                }.padding(.horizontal, 20)
                
                HStack{
                    ZStack{
                        DRBCircularSlider(data: sv2)
                        VStack{
                            Text("Short Break").font(.headline)
                            Text("\(Int(self.sv2.value))").font(.largeTitle)
                        }
                    }
                    
                    ZStack{
                        DRBCircularSlider(data: sv3)
                        VStack{
                            Text("Long Break").font(.headline)
                            Text("\(Int(self.sv3.value))").font(.largeTitle)
                        }
                    }
                }.padding(.horizontal)
                

                Text("All units are in minutes.").foregroundColor(Color.gray).padding(.top, 30)
                
                Spacer()
                }.padding()
            .navigationBarTitle("Time Setting")
            
            .navigationBarItems(
                leading: Button(action:{
                    self.timeSettingSheet.toggle()
                }){
                    Text("Cancel").bold()
                },
                trailing: Button(action:{
                    
                    //self.goalTimeInMin = Int(self.tempGoalTime)
                    self.goalTimeInMin = Int(self.sv1.value)
                    self.goalTime = self.goalTimeInMin*60
                    
                    //self.breakTimeInMin = Int(self.tempBreakTime)
                    self.breakTimeInMin = Int(self.sv2.value)
                    self.breakTime = self.breakTimeInMin*60
                    
                    //self.longBreakInMin = Int(self.tempLongBreak)
                    self.longBreakInMin = Int(self.sv3.value)
                    self.longBreak = self.longBreakInMin*60
                    
                    let newTimeSet = TimeSetting(context: self.moc)
                    newTimeSet.studyTime = Int32(self.goalTime)
                    newTimeSet.shortBreak = Int32(self.breakTime)
                    newTimeSet.longBreak = Int32(self.longBreak)
                    newTimeSet.newDate = Date()
                    try? self.moc.save()
                    
                    
                    self.timeSettingSheet.toggle()
                }){
                    Text("Save").bold()
            })
            
        
        }
        .onAppear{
            self.tempGoalTime = Double(self.goalTimeInMin)
            self.tempBreakTime = Double(self.breakTimeInMin)
            self.tempLongBreak = Double(self.longBreakInMin)
            
            self.sv1.initial = self.tempGoalTime
            
            if self.tempBreakTime == 1{
                self.sv2.initial = self.tempBreakTime
            }else{
                self.sv2.initial = self.tempBreakTime * 6
            }
            
            if self.tempLongBreak == 1{
                self.sv3.initial = self.tempLongBreak
            }else{
                self.sv3.initial = self.tempLongBreak * 3
            }

            
            
        }
    }
}


