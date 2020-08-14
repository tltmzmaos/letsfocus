//
//  PomodoroExplainView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/14/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI

struct PomodoroExplainView: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. The technique uses a timer to break down work into intervals, traditionally 25 minutes in length, separated by short breaks. Each interval is known as a pomodoro, from the Italian word for 'tomato', after the tomato-shaped kitchen timer that Cirillo used as a university student.\n\nThe technique has been widely popularized by dozens of apps and websites providing timers and instructions. Closely related to concepts such as timeboxing and iterative and incremental development used in software design, the method has been adopted in pair programming contexts.").multilineTextAlignment(.leading).padding().fixedSize(horizontal: false, vertical: true)

            }
            Image(uiImage: UIImage(named: "tomato")!)
            Spacer()

        }.navigationBarTitle("Pomodoro Technique")

        

    }
}

struct PomodoroExplainView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroExplainView()
    }
}
