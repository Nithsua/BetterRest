//
//  ContentView.swift
//  Better Rest
//
//  Created by Nivas Muthu M G on 30/06/21.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 7.0
    @State private var wakeUp = Calendar.current.date(from: DateComponents(hour: 6, minute: 0)) ?? Date()
    @State private var coffeeAmount = 3
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    private var wakeTime: String {
        let model = SleepModel()
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hours = (dateComponent.hour ?? 0) * 60 * 60
        let minutes = (dateComponent.minute ?? 0) * 60
        var sleepTimeString = ""
        do {
            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            sleepTimeString = formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            showingAlert = true
        }
        return sleepTimeString
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Pick your wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("Desired Amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.5) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                Section(header: Text("Daily coffee intake")) {
                    Picker("\(coffeeAmount) \(coffeeAmount < 2 ? "cup of coffee" : "cups of coffee")", selection: $coffeeAmount){
                        ForEach(0..<21) {
                            Text("\($0) \($0 < 2 ? "cup of coffee" : "cups of coffee")")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationBarTitle("Better Rest")
            .navigationBarItems(trailing: VStack{
                Text("Estimated Bedtime")
                    .font(.caption2)
                Text("\(wakeTime)")
                    .font(.title2)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
