//
//  ContentView.swift
//  Challenge95
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 14/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var oldValues = [Int]()
    @State private var currentValue = 0
    @State private var isRollingDice = false
    @State private var numberOfTries = 0
    @State private var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Image(systemName: currentValue > 0 ? "die.face.\(currentValue).fill" : "questionmark.diamond.fill")
                    .renderingMode(.template)
                    .font(.system(size: 140))
                    .foregroundStyle(.orange)
                    .frame(height: 220)
                
                Button(action: {
                    startRollingDice()
                }, label: {
                    Text("Roll dice")
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .opacity(isRollingDice ? 0.3 : 1.0)
                        .clipShape(.capsule)
                })
                .disabled(isRollingDice)
                
                if oldValues.isEmpty == false {
                    HStack {
                        Text("Old values")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(oldValues, id: \.self) { item in
                            Text(String(item))
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
            }
            .navigationTitle("Dice App")
            .onReceive(timer) { _ in
                guard isRollingDice else { return }
                
                numberOfTries += 1
                
                rollDice()
                if numberOfTries == 10 {
                    isRollingDice = false
                    
                    oldValues.insert(currentValue, at: 0)
                    timer.upstream.connect().cancel()
                }
            }
        }
    }
    
    func rollDice() {
        withAnimation {
            currentValue = Int.random(in: 1...6)
        }
    }
    
    func startRollingDice() {
        numberOfTries = 0
        isRollingDice = true
        timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    }
}

#Preview {
    ContentView()
}
