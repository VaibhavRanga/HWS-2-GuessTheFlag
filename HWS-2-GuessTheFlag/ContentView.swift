//
//  ContentView.swift
//  HWS-2-GuessTheFlag
//
//  Created by Vaibhav Ranga on 30/03/24.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 10)
    }
}

struct CustomFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
            .foregroundStyle(.blue)
    }
}

extension View {
    func customFont() -> some View {
        modifier(CustomFont())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var displayScoreAlert = false
    @State private var displayGameOverAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    
    @State private var selectedAnswer = -1
    @State private var animationRotationAmount = 0.0
    @State private var animationOpacity = 1.0
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .customFont()
                            .modifier(CustomFont())
//                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                            
//                            Image(countries[number])
//                                .clipShape(.rect(cornerRadius: 10))
//                                .shadow(radius: 10)
                        }
                        .rotation3DEffect(.degrees(selectedAnswer == number ? animationRotationAmount : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .opacity( !(selectedAnswer == number) ? animationOpacity : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $displayScoreAlert) {
            Button("Continue", action: askQuestion)
            Button("Restart Quiz", action: resetQuiz)
        } message: {
            Text("Your score is: \(score)/\(questionCount)")
        }
        
        .alert("Game over", isPresented: $displayGameOverAlert) {
            Button("Restart Quiz", action: resetQuiz)
        } message: {
            Text("Your score is: \(score)/\(questionCount)")
        }
        
        /*
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of:")
                        .foregroundStyle(.white)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .foregroundStyle(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: ???")
        }
         */
    }
    
    func flagTapped(_ number: Int) {
        selectedAnswer = number
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong!"
        }
        
        withAnimation {
            animationRotationAmount += 360
            animationOpacity = 0.25
        }
        
        questionCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if questionCount == 8 {
                displayGameOverAlert = true
            } else {
                displayScoreAlert = true
            }
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedAnswer = -1
        animationOpacity = 1.0
    }
    
    func resetQuiz() {
        questionCount = 0
        score = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
