//
//  ContentView.swift
//  PomodoroIOS
//
//  Created by Seyit Murat Kaya on 18.02.2022.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    
    @State var studyLength = 25 * 60
    @State var breakLength = 0
    @State var timeCount = 0
    @State var minutes = 0
    @State var seconds = 0
    @State var isBreakeTime: Bool = false
    @State var timerIsPaused: Bool = false
    @State var IsRunning:Bool = false
    @State var timerValue:Int = 0
    @State var pomodoroCount = 0
    @State var timer : Timer?
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func startTimer(length:Int){
        IsRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ tempTimer in
            if timeCount > 0{
                (minutes,seconds) = secondsToMinutesSeconds(timeCount)
                timeCount -= 1
            }else if timeCount == 0{
                timer?.invalidate()
                if isBreakeTime{
                    startStudy()
                }else{
                    pomodoroCount += 1
                    startBreak()
                }
            }
        }
    }
    
    func startStudy(){
        if timerIsPaused{
            if isBreakeTime{
                startTimer(length: timeCount)
            }else{
                isBreakeTime = false
                startTimer(length: timeCount)
            }
        }else{
            isBreakeTime = false
            timeCount = studyLength
            startTimer(length: timeCount)
        }
        timerIsPaused = false
    }
    
    func startBreak(){
        timerIsPaused = false
        isBreakeTime = true
        if pomodoroCount % 4 == 0{
            breakLength = 20 * 60
        }else{
            breakLength = 5 * 60
        }
        timeCount = breakLength
        startTimer(length: timeCount)
    }
    
    func pauseTimer(){
        IsRunning = false
        timerIsPaused = true
        timer?.invalidate()
        timeCount = minutes * 60 + seconds - 1
    }
    
    func resetTimer(){
        if isBreakeTime {
            startBreak()
        }else{
            startStudy()
        }
    }
    
    var body: some View {
        ZStack{
            isBreakeTime ? Color(red: 0.59, green: 0.75, blue: 0.71) : Color(red: 0.67, green: 0.29, blue: 0.28)
            VStack{
                Spacer()
                Text("\(minutes):\(seconds)")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                HStack{
                    Text("Pomodoro Count:")
                    Text(String(pomodoroCount))
                }.foregroundColor(.white)
                Spacer()
                HStack{
                    if IsRunning{
                        ButtonView(text: "Pause",function: pauseTimer)
                    }else{
                        ButtonView(text: "Start",function: startStudy)
                    }
                    ButtonView(text: "Reset", function: resetTimer)
                }
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
