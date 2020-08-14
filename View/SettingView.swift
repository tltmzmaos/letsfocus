//
//  SettingView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/12/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI
import MessageUI
import StoreKit


struct SettingView: View {
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isMailViewShowing = false
    @State var noMailAlert = false
    
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    var body: some View{
        NavigationView{
            List{
                Section{
                    
                    NavigationLink(destination: PomodoroExplainView()){
                        HStack{
                            Image(systemName: "questionmark.circle")
                            Text("What is Pomodoro technique?")
                        }
                    }
                }
                
                Section{
                    NavigationLink(destination: ProgressView()){
                        HStack{
                            Image(systemName: "chart.bar")
                            Text("Usage Report")
                        }
                        
                    }
                }
                
                Section{
                    Button(action:{
                        if MFMailComposeViewController.canSendMail(){
                            self.isMailViewShowing.toggle()
                            self.noMailAlert = false
                        }else{
                            self.noMailAlert = true
                        }
                    }){
                        HStack{
                            Image(systemName: "paperplane")
                            Text("Help / Feedback")
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }.alert(isPresented: $noMailAlert){
                        Alert(title: Text("Alert"),
                              message: Text("You need to setup a mail account"),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    Button(action:{
                        SKStoreReviewController.requestReview()
                    }){
                        HStack{
                            Image(systemName: "pencil")
                            Text("Rate this app")
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    
                }
                
                Section{
                    NavigationLink(destination: SourceView()){
                        HStack{
                            Image(systemName: "link")
                            Text("Source")
                        }
                    }
                }
                
            }

            .listStyle(GroupedListStyle())
            //.environment(\.horizontalSizeClass, .regular)
            .sheet(isPresented: $isMailViewShowing){
                MailView(isShowing: self.$isMailViewShowing, result: self.$result)
            }
            .onAppear{
                UITableView.appearance().separatorStyle = .none
            }
                
            .navigationBarTitle("More")
        }
        
    }
    
}
