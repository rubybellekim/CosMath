//
//  ContentView.swift
//  CosMath
//
//  Created by Ruby Kim on 2024-10-13.
//

import Observation
import SwiftUI


struct ContentView: View {
    
    //calculating part
    struct Question {
        var operand1: Int
        var operand2: Int
        
        var answer: Int {
            operand1 * operand2
        }
        
        var questionText: String {
            "\(operand1) x \(operand2) = ?"
        }
        
        var stackQuestion: String {
            "\(operand1) x \(operand2) = \(answer.description)"
        }
    }
    
    //custom user input keypad button(each)
    struct KeypadButton: View {
        var label: String
        var action: () -> Void
        
        var body: some View {
            Button(action: {
                action()
            }) {
                Text(label)
                    .font(FontStyles.body)
                    .frame(width: 80, height: 60)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(3)
            }
        }
    }
    
    //custom user input keypad(whole)
    struct KeypadView: View {
        @Binding var inputValue: String
        @State private var counter = 0
        
        let columns = [
            GridItem(.fixed(80)),
            GridItem(.fixed(80)),
            GridItem(.fixed(80))
        ]
        
        var body: some View {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1..<10) { number in
                    KeypadButton(label: "\(number)") {
                        inputValue.append("\(number)")
                        counter += 1
                    }
                    .sensoryFeedback(.increase, trigger: counter)
                }
                
                // Empty button to maintain the keypad layout
                KeypadButton(label: "") {}
                
                KeypadButton(label: "0") {
                    inputValue.append("0")
                }
                
                KeypadButton(label: "⌫") {
                    if !inputValue.isEmpty {
                        inputValue.removeLast()
                    }
                }
            }
        }
    }
    
    //start screen planet images grid
    struct GridImagesView: View {
        let rows = [
            GridItem(.adaptive(minimum: 100, maximum: 500)), // Adjust max as needed
            GridItem(.adaptive(minimum: 100, maximum: 500)), // Adjust max as needed
            GridItem(.adaptive(minimum: 100, maximum: 500)) // Adjust max as needed
        ]
        
        let images = ["Earth", "FullMoon", "RedPlanet", "PurplePlanet", "Saturn", "Sun", "BluePlanet", "WhiteMoon", "WhiteStar"]
        
        var body: some View {
            GeometryReader { geometry in
                let horizontalPadding = max((geometry.size.width - (CGFloat(images.count) * 30)) / 2, 0)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 50) {
                        ForEach(images, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
            }
            .frame(height: 320) // Adjust the height as needed
        }
    }
    
    //silver button(start, restart)
    struct SilverButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .frame(minWidth: 180, minHeight: 60)
                    .background(LinearGradient(colors: [.gray, .white, .gray], startPoint: .top, endPoint: .bottom))
                    .foregroundStyle(.black.opacity(0.5))
                    .cornerRadius(10)
                    .font((.custom("Futura", fixedSize: 30))
                          )
                    .shadow(
                            color: Color.primary.opacity(0.3), /// shadow color
                            radius: 2, /// shadow radius
                            x: 3, /// x offset
                            y: 6 /// y offset
                        )
                    .scaleEffect(configuration.isPressed ? 2.0 : 1)
                    .animation(.easeOut(duration: 0.8), value: configuration.isPressed)
            }
    }

    //black button(answer submit)
    struct BlackButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .frame(minWidth: 250, minHeight: 60)
                    .background(LinearGradient(colors: [.black, .gray, .black], startPoint: .top, endPoint: .bottom))
                    .foregroundStyle(.white.opacity(0.8))
                    .cornerRadius(10)
                    .font((.custom("Futura", fixedSize: 30))
                    )
                    .shadow(
                            color: Color.primary.opacity(0.3), /// shadow color
                            radius: 2, /// shadow radius
                            x: 3, /// x offset
                            y: 6 /// y offset
                        )
                    .scaleEffect(configuration.isPressed ? 1.5 : 1)
                    .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
            }
    }
    
    enum GameState {
        case main, settings, game, score
    }
    @State private var currentState: GameState = .main
    
    
    // ---state variables---
    @State private var inputValue: String = ""
    
    @State private var isGameStarted = false
    @State private var isGameOver = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showScore = false
    
    @State private var selectedTable = 2
    @State private var numOfQuestions = 5
    @State private var numOfQuestion = 0
    @State private var difficulty = "Medium"
    
    @State private var score = 0
    @State private var page = 1
    
    @State private var questionArray = [String]()
    @State private var answerArray = [Int]()
    @State private var questionSave = [String]()
    
    @State private var userAnswer: Int = 0
    @State private var answer = 0
    @State private var currentQuestion = 0
    @State private var displayQuestion = ""
    @State private var planet = ""
    

    //functions
    func generateQuestions() {
        numOfQuestion = 0
        isGameStarted = true
        isGameOver = false
        
        questionArray.removeAll()  // Clear previous questions
        answerArray.removeAll()  // Clear previous answers
        
        while numOfQuestion < numOfQuestions {
            let multiplier = getMultiplier()
            
            let problem = Question(operand1: selectedTable, operand2: multiplier)
            
            let questionText = problem.questionText
            let answer = problem.answer
            let stackQuestion = problem.stackQuestion
            
            questionArray.append(questionText)
            answerArray.append(answer)
            
            questionSave.append(stackQuestion)
            
            numOfQuestion += 1
        }
    }
    
    private func getMultiplier() -> Int {
        switch difficulty {
        case "Easy":
            return Int.random(in: 1...5)
        case "Medium":
            return Int.random(in: 1...10)
        case "Hard":
            return Int.random(in: 1...12)
        default:
            return 1
        }
    }

    private func planetGenerator() {
        switch score {
        case ...0:
            return planet = "WhiteStar"
        case 10...30:
            return planet = "Earth"
        case 40...60:
            return planet = "FullMoon"
        case 70...100:
            return planet = "Saturn"
        case 110...150:
            return planet = "RocketWhite"
        case 160...:
            return planet = "Sun"
        default:
            return planet = "YellowShootingStar"
        }
    }

    
    func setQuestion() {
        if currentQuestion != numOfQuestion {
            let question = questionArray[currentQuestion]
            displayQuestion = question
            
            let setAnswer = answerArray[currentQuestion]
            answer = setAnswer
            
            userAnswer = 0
            
        } else {
            showAlert = true
            isGameOver = true
        }
    }
    
    func checkAnswer() {
        userAnswer = Int(inputValue) ?? 0
        if answer == userAnswer {
            score += 10
            alertMessage = "Correct!"
        } else {
            score -= 10
            alertMessage = "Wrong!"
        }
        
        currentQuestion += 1
        showAlert = true
    }
    
    
    func startNewGame() {
        currentQuestion = 0
        numOfQuestion = 0
        score = 0
        page = 1
        questionSave.removeAll()
        isGameStarted = false
        isGameOver = false
        selectedTable = 2
        numOfQuestions = 5
        numOfQuestion = 0
        difficulty = "Medium"
        currentState = GameState.main
    }
    
    //-----screenViews----
    
    //screen1: main
    private var mainScreenView: some View {
        VStack {
            //title logo
            Image("title-cosmath")
                .resizable()
                .scaledToFit()
                .frame(width: 420)
            
            //planets image grid
            GridImagesView()
            
            //button to setting screen
            Button("EXPLORE") {
                currentState = GameState.settings
            }
            .buttonStyle(SilverButton())
            .padding(.top, 20)
        }
    }
    
    //screen2: setting
    private var settingsScreenView: some View {
        VStack {
            SettingView(selectedTable: $selectedTable, numOfQuestions: $numOfQuestions, difficulty: $difficulty)
            
            //button to generate the game
            Button("START") {
                isGameStarted = true
                currentState = GameState.game
                generateQuestions()
            }
            .buttonStyle(SilverButton())
        }
    }
    
    
    //screen3: games
    private var gameScreenView: some View {
        VStack {
            //indications of how many questions solved & to go
            Text("\(page) / \(numOfQuestions)")
                .font(FontStyles.body)
                .foregroundStyle(.black.opacity(0.6))
                .padding(.bottom, 10)
            
            //generated questions displaying here
            Text(displayQuestion)
                    .font(FontStyles.title)
                    .foregroundStyle(.white.opacity(0.9))
            VStack {
                //user input displaying here
                Text("\(inputValue)")
                    .font(FontStyles.xlarge)
                    .padding()
                
                //custom keypad for more fun and easier operation instead of regular text input
                KeypadView(inputValue: $inputValue)
                
                //button to submit the answer & display the alerts
                Button("SUBMIT") {
                    checkAnswer()
                    
                    if page == numOfQuestions {
                        //do nothing
                    } else {
                        page += 1
                    }
                    
                    inputValue = ""
                }
                .buttonStyle(BlackButton())
                
                //button going back to the main screen
                Button("RESTART") {
                    startNewGame()
                }
                .background(Color.clear)
                .foregroundColor(.black.opacity(0.5))
                .font(FontStyles.caption)
                .padding(.top, 5)
            }
            VStack {
                //displaying user's current score here
                Text("Score: \(score)")
                    .font(FontStyles.title)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding()
        }
        .onAppear(perform: setQuestion)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") {
                setQuestion()
                //check if it is the last question in queue, let the game ends and show the score page
                if isGameOver {
                    isGameStarted = false
                    planetGenerator()
                    currentState = GameState.score
                    //to set the state variable 'planet' and make it reusable in levelGenerator() func
                } else {
                    
                }
            }
        }
    }
    
    
    //screen4: answer sheet and result
    private var scoreScreenView: some View {
        VStack(alignment: .center) {
            ResultView(questionSave: $questionSave, score: $score, planet: $planet)
                //button going back to the main screen
                Button("RESTART") {
                    startNewGame()
                }
            .buttonStyle(SilverButton())
            .padding(.top, 20)
        }
    }
    
    var body: some View {
        
        //background gradients colour
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .blue, .purple, .indigo, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            // ---decide which screen to display ---
            VStack {
                switch currentState {
                    case .main:
                        // Main Screen
                        mainScreenView

                    case .settings:
                        // Settings Screen
                        settingsScreenView

                    case .game:
                        // Game Screen
                        gameScreenView

                    case .score:
                        // Score Screen
                        scoreScreenView
                    }
                }
            }
            .preferredColorScheme(.light) // Forces light mode
    }
}


#Preview {
    ContentView()
}
