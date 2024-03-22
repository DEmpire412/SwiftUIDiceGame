import SwiftUI

//Main view
struct ContentView: View {
    @State private var player1Dice: [Int]
    @State private var player2Dice: [Int]
    @State private var player1Score: Int = 0
    @State private var player2Score: Int = 0
    @State private var result: String = ""
    @State private var rollCount: Int = 0
    @State private var isHistoryPopoverVisible = false
    @State private var rollHistory: [String] = []
    @State private var currentPlayer: Player = .player1
    @State private var isShowingSettings = false
    @AppStorage ("selectedColor") private var selectedColor = 0
    @AppStorage("turnsPerPlayer") private var turnsPerPlayer = 3

    enum Player {
        case player1
        case player2
    }

    init() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            player1Dice = Array(repeating: 1, count: 3)
            player2Dice = Array(repeating: 1, count: 3)
        } else {
            player1Dice = Array(repeating: 1, count: 6)
            player2Dice = Array(repeating: 1, count: 6)
        }
    }

    var body: some View {
        let color = getColorForSelectedIndex(selectedColor)
        
        ZStack {
            Color(UIColor(color))
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isShowingSettings = true
                        }) {
                            Image(systemName: "gearshape")
                                .padding()
                                .fontDesign(.rounded)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .hoverEffect(.automatic)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            isHistoryPopoverVisible = true
                        }) {
                            Text("Roll History")
                                .padding()
                                .fontDesign(.rounded)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .hoverEffect(.automatic)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            clearScoreHistory()
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .fontDesign(.rounded)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .hoverEffect(.automatic)
                                .shadow(radius: 5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    .sheet(isPresented: $isShowingSettings) {
                        SettingsView()
                    }
                    Spacer()
                        .frame(height: 20)
                    Text("Dice Game")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                        )
                    Spacer()
                        .frame(height: 20)
                    Text("Player 1")
                        .fontDesign(.rounded)
                        .foregroundColor(currentPlayer == .player1 ? Color.white : Color.black)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(currentPlayer == .player1 ? Color.red : Color.white)
                                .shadow(radius: 5)
                        )
                    
                    HStack {
                        ForEach(player1Dice.indices, id: \.self) { index in
                            DieView(value: player1Dice[index])
                        }
                    }
                    
                    Text("Score: \(player1Score)")
                        .fontDesign(.rounded)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                        )
                }
                VStack {
                    Text(result)
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .padding()
                    
                    Text("Player 2")
                        .fontDesign(.rounded)
                        .foregroundColor(currentPlayer == .player2 ? Color.white : Color.black)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(currentPlayer == .player2 ? Color.red : Color.white)
                                .shadow(radius: 5)
                        )
                    
                    HStack {
                        ForEach(player2Dice.indices, id: \.self) { index in
                            DieView(value: player2Dice[index])
                        }
                    }
                    
                    Text("Score: \(player2Score)")
                        .fontDesign(.rounded)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                        )
                    
                    Button(action: {
                        rollDice()
                    }) {
                        Text("Roll")
                            .padding()
                            .fontDesign(.rounded)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .hoverEffect(.automatic)
                            .shadow(radius: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isHistoryPopoverVisible) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isHistoryPopoverVisible = false
                    }) {
                        Image(systemName: "xmark.circle")
                            .fontWeight(.semibold)
                            .hoverEffect()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Text("Roll History")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                List(rollHistory, id: \.self) { rollResult in
                    Text(rollResult)
                        .font(.body)
                        .padding()
                }
                .listStyle(PlainListStyle())
                .padding()
            }
        }
    }

    
    func getColorForSelectedIndex(_ index: Int) -> Color {
        switch index {
        case 0:
            return Color.green
        case 1:
            return Color.red
        case 2:
            return Color.orange
        case 3:
            return Color.yellow
        case 4:
            return Color.blue
        case 5:
            return Color.purple
        case 6:
            return Color.pink
        case 7:
            return Color.gray
        default:
            return Color.green
        }
    }

    func clearScoreHistory() {
        resetDice()
        player1Score = 0
        player2Score = 0
        result = ""
        rollCount = 0
        rollHistory.removeAll()
        isHistoryPopoverVisible = false
        currentPlayer = .player1
    }

    func resetDice() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            player1Dice = Array(repeating: 1, count: 3)
            player2Dice = Array(repeating: 1, count: 3)
        } else {
            player1Dice = Array(repeating: 1, count: 6)
            player2Dice = Array(repeating: 1, count: 6)
        }
    }

    func rollDice() {
        let newDice: [Int]

        if UIDevice.current.userInterfaceIdiom == .phone {
            newDice = (1...3).map { _ in Int.random(in: 1...6) }
        } else {
            newDice = (1...6).map { _ in Int.random(in: 1...6) }
        }

        switch currentPlayer {
        case .player1:
            withAnimation {
                player1Dice = newDice
            }
            let player1ScoreIncrease = newDice.reduce(0, +)
            player1Score += player1ScoreIncrease
            let rollResult = "Roll \(rollCount + 1): Player 1 - \(player1ScoreIncrease)"
            rollHistory.append(rollResult)
        case .player2:
            withAnimation {
                player2Dice = newDice
            }
            let player2ScoreIncrease = newDice.reduce(0, +)
            player2Score += player2ScoreIncrease
            let rollResult = "Roll \(rollCount + 1): Player 2 - \(player2ScoreIncrease)"
            rollHistory.append(rollResult)
        }

        rollCount += 1

        if rollCount >= (turnsPerPlayer * 2) {
            endGame()
        } else {
            currentPlayer = currentPlayer == .player1 ? .player2 : .player1
        }
    }

    func endGame() {
        if player1Score > player2Score {
            result = "Player 1 wins! Score: \(player1Score)"
        } else if player2Score > player1Score {
            result = "Player 2 wins! Score: \(player2Score)"
        } else {
            result = "It's a tie! Score: \(player1Score)"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            clearScoreHistory()
        }
    }
}

struct DieView: View {
    let value: Int
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(radius: 5)

            VStack(spacing: 15) {
                if value > 1 && value < 6 {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }

                if value % 2 == 1 {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }

                if value > 3 && value < 6 {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                
                if value == 6 {
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .rotationEffect(Angle(degrees: rotationAngle))
            .animation(.spring())
        }
        .onChange(of: value) { _ in
            rollDiceAnimation()
        }
    }

    private func rollDiceAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            rotationAngle += 360
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
