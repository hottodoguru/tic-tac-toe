//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Chanoknun Choosaksilp on 23/8/2564 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    @Binding var whoStart : Bool
    @State private var count = 0
    
    var body: some View {
        NavigationView{
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]){
                ForEach(0..<9){i in
                    ZStack {
                        Color.red
                            .opacity(0.5)
                            .frame(width: squareSize(), height: squareSize())
                            .cornerRadius(15)
                        
                        Image(systemName: moves[i]? .mark ?? "xmark.circle")
                            .resizable()
                            .frame(width: markSize(), height: markSize())
                            .foregroundColor(.white)
                            .opacity(moves[i] == nil ? 0 : 1)
                    }
                    .onAppear(){
                        if (whoStart == false) && (count == 0) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determinComputerMove(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled.toggle()
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                }
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                            isGameboardDisabled.toggle()
                            count+=1
                        }
                    }
                    .onTapGesture {
                        if whoStart == true {
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human , boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameboardDisabled.toggle()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determinComputerMove(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled.toggle()
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                }
                            }
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determinComputerMove(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled.toggle()
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                }
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human , boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameboardDisabled.toggle()
                            
                            
                        }
                    }
                }
            }
            .padding()
            .disabled(isGameboardDisabled)
            .navigationTitle("Tic Tac Toe")
            .alert(item: $alertItem){ alertItem in
                Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: .default(Text(alertItem.buttonTitle), action: resetGame))
                
            }
            
        }
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
        whoStart.toggle()
        if(whoStart == false){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let computerPosition = determinComputerMove(in: moves)
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                //isGameboardDisabled.toggle()
                
                if checkWinCondition(for: .computer, in: moves){
                    alertItem = AlertContext.computerWin
                }
            }
        }
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Array<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        //let playerMoves = moves.compactMap { $0 }.filter { $0.player == player}
        //let playerPositions = playerMoves.map { $0.boardIndex }
        let playerPositions = Set(moves.compactMap { $0 }.filter { $0.player == player}.map { $0.boardIndex })
        for pattern in winPatterns {
            if pattern.isSubset(of: playerPositions){
                return true
            }
        }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap{ $0 }.count == 9
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index:Int) -> Bool{
        moves[index] != nil
    }
    
    func determinComputerMove(in moves: [Move?]) -> Int {
        //If AI can win, then wins
        let winPatterns: Array<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerPositions = Set(moves.compactMap { $0 }.filter { $0.player == .computer}.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: winPositions.first!){
                    return winPositions.first!
                }
            }
        }
        
        //If AI can't win, then blocks
        let humanPositions = Set(moves.compactMap{ $0 }
                                    .filter{$0.player == .human}
                                    .map {$0.boardIndex})
        for pattern in winPatterns {
            let blockPositions = pattern.subtracting(humanPositions)
            if blockPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: blockPositions.first!){
                    return blockPositions.first!
                }
            }
        }
        
        //If AI can't block, then take middle square
        let middlePosition = 4
        if !isSquareOccupied(in: moves, forIndex: middlePosition){
            return middlePosition
        }
        //If AI can't take middle square then random available
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func squareSize() -> CGFloat {
        UIScreen.main.bounds.width / 3  - 15 //Tell Screen Size
    }
    func markSize() -> CGFloat{
        squareSize() / 2
    }
}
enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var mark: String {
        player == .human ? "xmark" : "circle"
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let buttonTitle: String
}

struct AlertContext {
    static let humanWin = AlertItem(title: "You Win !", message: "You are so smart damnnn", buttonTitle: "Hell Yeah")
    static let draw = AlertItem(title: "Draw", message: "What a battle", buttonTitle: "Try Again")
    static let computerWin = AlertItem(title: "You Lost !", message: "Are you stupid ?", buttonTitle: "LMAO no")
    static let humanFirst = AlertItem(title: "You start first !", message: "You First",buttonTitle: "Okay")
    static let comFirst = AlertItem(title: "Computer start first !", message: "Me First", buttonTitle: "Go Ahead")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(whoStart: Binding.constant(false))
        
    }
}
