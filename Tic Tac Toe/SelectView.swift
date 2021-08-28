//
//  SelectView.swift
//  Tic Tac Toe
//
//  Created by Chanoknun Choosaksilp on 23/8/2564 BE.
//

import SwiftUI

struct SelectView: View {
    @State private var whoStart = false
    @State private var isPresent = false
    var body: some View {
        
        VStack {
            Text("Who plays first ?").padding().font(.title)
            Spacer()
            HStack(spacing: 0){
                Button("You"){
                    whoStart = false
                    isPresent.toggle()
                }
                .frame(width: 150, height: 70, alignment: .center)
                .border(Color.black, width: 2)
                .fullScreenCover(isPresented: $isPresent, content: {
                    ContentView(whoStart: $whoStart)
                })
                Button("Me"){
                    whoStart = true
                    isPresent.toggle()
                }
                .frame(width: 150, height: 70, alignment: .center)
                .border(Color.black, width: 2)
                .fullScreenCover(isPresented: $isPresent, content: {
                    ContentView(whoStart: $whoStart)
                })
            }
        }
        .frame(width: 300, height: 200, alignment: .center)
        .background(Color.red.opacity(0.2))
        .border(Color.black)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
