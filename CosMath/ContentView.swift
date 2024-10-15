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
                    }
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
                GridItem(.fixed(100)),  // Row 1
                GridItem(.fixed(100)),  // Row 2
                GridItem(.fixed(100))   // Row 3
            ]
        
        let images = ["Earth", "FullMoon", "RedPlanet", "PurplePlanet", "Saturn", "Sun", "BluePlanet", "WhiteMoon", "WhiteStar"]
        
        var body: some View {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 50) {
                        ForEach(images, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                    }
                    .padding(.leading, 80)
                }
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
    
    //pre-arranged custom fonts
    struct FontStyles {
        static let xlarge = Font.custom("Futura Bold", size: 48)
        static let title = Font.custom("Futura Bold", size: 30)
        static let body = Font.custom("Futura Bold", size: 22)
        static let caption = Font.custom("Futura Medium", size: 18)
    }
    
    // ---state variables---
    @State private var inputValue: String = ""
    
    @State private var isGameStarted = false
    @State private var isSetting = false
    @State private var isMain = true
    @State private var isGameOver = false
    @State private var isScore = false
    
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
    
    
    // ---functions---
    func incrementStep() {
        numOfQuestions += 5
        if numOfQuestions > 21 { numOfQuestions = 20 }
    }
    
    func decrementStep() {
        numOfQuestions -= 5
        if numOfQuestions < 4 { numOfQuestions = 5 }
    }
    
    func generateQuestions() {
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
    
    private func levelGenerator() -> String {
        switch planet {
        case "WhiteStar":
            return "level 1: Star Baby"
        case "Earth":
            return "level 2: Earth Human"
        case "FullMoon":
            return "level 3: Moon Walker"
        case "Saturn":
            return "level 4: Space Cowboy"
        case "RocketWhite":
            return "level 5: Rocket Emperor"
        case "Sun":
            return "level 6: Sun Demigod"
        default:
            return "level 0: Infinite"
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
        questionSave.removeAll()
        isGameStarted = false
        isSetting = false
        isGameOver = false
        isMain = true
        isScore = false
    }

    
    //local variables
    let tables = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let difficulties = ["Easy", "Medium", "Hard"]

    
    var body: some View {
        
        //background gradients colour
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .blue, .purple, .indigo, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            // ---decide which screen to display ---
            VStack {
                
                //screen1: main
                if isMain {
                    
                    //title logo
                    Image("title-cosmath")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420)
                    
                    //planets image grid
                    GridImagesView()
                        
                    //button to setting screen
                    Button("EXPLORE") {
                        isSetting = true
                        isMain = false
                    }
                    .buttonStyle(SilverButton())
                    .padding(.top, 20)
                }
                
                //screen2: setting
                if isSetting
                {
                    //title
                    Text("Customize your game")
                        .font(FontStyles.title)
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(
                                color: Color.primary.opacity(0.3), /// shadow color
                                radius: 5, /// shadow radius
                                x: 3, /// x offset
                                y: 6 /// y offset
                            )
                    
                    // ---game settings---
                    ZStack {
                        //container boxs design
                        Rectangle()
                            .fill(Color.black.opacity(0.1)) // Light gray background
                                        .cornerRadius(20) // Rounded corners
                                        .padding() // Padding around the rectangle
                        VStack(alignment: .leading) {
                            Text("Choose Times Table")
                                .font(FontStyles.body)
                                .foregroundStyle(.black.opacity(0.7))
                            Divider()
                                .frame(width: 300, height: 1.5)
                                .overlay(.black.opacity(0.5))
                                .padding(.bottom, 10)
                            Picker("", selection: $selectedTable) {
                                ForEach(tables, id: \.self) {
                                    Text("\($0)")
                                        .font(FontStyles.body)
                                }
                            }
                            .font(FontStyles.body)
                            .pickerStyle(.segmented)
                        }
                        .frame(width: 300)
                        }
                    ZStack {
                        //container boxs design
                        Rectangle()
                            .fill(Color.black.opacity(0.1)) // Light gray background
                            .cornerRadius(20) // Rounded corners
                            .padding() // Padding around the rectangle
                        VStack(alignment: .leading) {
                            //let users decides how many questions to challenge(5 to 20, step: 5)
                            Text("How many questions")
                                .font(FontStyles.body)
                            Divider()
                                .frame(width: 300, height: 1.5)
                                .overlay(.black.opacity(0.5))
                                .padding(.bottom, 10)
                            Stepper("\(numOfQuestions)", onIncrement: {
                                incrementStep()
                            }, onDecrement: {
                                decrementStep()
                            })
                            .font(FontStyles.body)
                            
                        }
                        .frame(width: 300)
                    }
                        
                    ZStack {
                        //container boxs design
                        Rectangle()
                                .fill(Color.black.opacity(0.1)) // Light gray background
                                .cornerRadius(20) // Rounded corners
                                .padding() // Padding around the rectangle
                        VStack(alignment: .leading) {
                            //let users decides set the difficulties and get the multipliers depends on it(esay: 1~5, medium: 1~10, hard: 1~12. refer the getMultiplier() func)
                            Text("Set Difficulties")
                                .font(FontStyles.body)
                            Divider()
                                .frame(width: 300, height: 1.5)
                                .overlay(.black.opacity(0.5))
                                .padding(.bottom, 10)
                            Picker("", selection: $difficulty) {
                                ForEach(difficulties, id: \.self) {
                                    Text("\($0)")
                                    .font(FontStyles.body)
                                }
                            }
                            .font(FontStyles.body)
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                        }
                    }
                    
                    Spacer()
                    
                    //button to generate the game
                    Button("START") {
                        isSetting = false
                        isGameStarted = true
                        generateQuestions()
                    }
                    .buttonStyle(SilverButton())
                }
                
                //screen3: games
                if isGameStarted {
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
                                isScore = true
                                planetGenerator() //to set the state variable 'planet' and make it reusable in levelGenerator() func
                            } else {
                                
                            }
                        }
                    }
                }
                
                //screen4: answer sheet and result
                if isScore {
                    VStack(alignment: .center) {
                        //title
                        Text("Answer Sheets & Result")
                            .font(FontStyles.body)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        //scrollview to displaying questions in this game and the correct answer sheets so that user can study them
                        ScrollView {
                            VStack {
                                ForEach(questionSave, id: \.self) { question in
                                    HStack {
                                        Text(question)
                                            .font(FontStyles.body)
                                            .padding()
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .background(Color.black.opacity(0.2)) // Optional background for each item
                            .cornerRadius(12) // Rounded corners
                        }
                            .padding(.bottom, 30)
                            .frame(maxHeight: 300)
 
                        VStack(alignment: .center) {
                            //showing planets depends on user's score instead of justing displaying number, give motivations and fun to aim the higher score for users
                            Text("Your planet is...")
                                .font(FontStyles.title)
                                .foregroundStyle(.white.opacity(0.9))
                                .shadow(
                                    color: Color.primary.opacity(0.3), /// shadow color
                                    radius: 5, /// shadow radius
                                    x: 3, /// x offset
                                    y: 6 /// y offset
                                )
                            HStack {
                                //the planet decides by score
                                Image(planet)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                HStack {
                                    //planet captions depends on the result
                                    Text(levelGenerator())
                                        .font(FontStyles.caption)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding()
                            //button going back to the main screen
                            Button("RESTART") {
                                startNewGame()
                            }
                            .buttonStyle(SilverButton())
                            .padding(.top, 20)
                        }
                    }
                
                }
                
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
