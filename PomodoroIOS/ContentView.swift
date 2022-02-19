//
//  ContentView.swift
//  PomodoroIOS
//
//  Created by Seyit Murat Kaya on 18.02.2022.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State var studyLength = 1 // minutes
    @State var breakLength = 0
    @State var timeCount = 0
    @State var minutes = 0
    @State var seconds = 0
    @State var isBreakeTime: Bool = true
    @State var isInBackground: Bool = false
    @State var timerValue:Int = 0
    @State var pomodoroCount = 0
    @State var timerIsPaused: Bool = true
    @State var timer : Timer?
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func startPomodoro(){
        isBreakeTime = false
        
        timerIsPaused = false
        timeCount = studyLength * 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ tempTimer in
            if timeCount > 0{
                (minutes,seconds) = secondsToMinutesSeconds(timeCount)
                timeCount -= 1
            }else if timeCount == 0{
                timer?.invalidate()
                startBreak()
            }
            
        }
    }
    func startBreak(){
        pomodoroCount += 1
        isBreakeTime = true
        if pomodoroCount % 4 == 0{
            breakLength = 20 * 60 //minutes
        }else{
            breakLength = 5 * 60 // minutes
        }
        
        timeCount = breakLength
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ tempTimer in
            if timeCount > 0{
                (minutes,seconds) = secondsToMinutesSeconds(timeCount)
                timeCount -= 1
            }else if timeCount == 0{
                timer?.invalidate()
                startPomodoro()
            }
            
        }
        
    }
    
    func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
    }
    func resetTimer(){
        timer?.invalidate()
    }
    func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
            if success {
                print("success")
            }else if let e = error{
                print(e.localizedDescription)
            }
        }
    }
    func sendNotification(secondsLeft:Int){
        let content = UNMutableNotificationContent()
        content.title = isBreakeTime ? "Break Time" : "Study Time"
        content.subtitle = isBreakeTime ? "\(breakLength) minutes break" : ""
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(secondsLeft), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
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
                    if timerIsPaused{
                        ButtonView(text: "Start",function: startPomodoro)
                    }else{
                        ButtonView(text: "Stop",function: stopTimer)
                    }
                    ButtonView(text: "Reset", function: resetTimer)
                }
                Spacer()
                
                
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            requestPermission()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active{
                print("active")
                if isInBackground{
                    
                }
            }else if newValue == .inactive{
                print("inactive")
            }else if newValue == .background{
                print("background")
                sendNotification(secondsLeft: timeCount)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
