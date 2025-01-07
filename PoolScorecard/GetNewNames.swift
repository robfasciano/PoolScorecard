//
//  GetNewnames.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI

//Probably should bind scores, too
struct GetNewNames: View {
    @Binding var names: [String]
    var count: Int
    
    
    @State private var showingPopover = Array.init(repeating: false, count: 6)

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(Color("Felt"))
                .ignoresSafeArea()
            
            VStack {
                BackButton()
                    .onTapGesture(perform: { dismiss() })
                Text("Edit Player Names")
                    .fontWeight(.black)
                Spacer()
                ScrollView {
                    VStack (spacing: 10) {
                        ForEach(0..<6) { i in
                            HStack {
                                theName(i: i)
                                swapButton(i: i)
                            }
                        }
                    }
                }
                Spacer()
            }
            .font(Font.custom(PoolScorecardApp.Constants.fontName, size: 80))
            .foregroundStyle(PoolScorecardApp.Constants.textColor1)
            .textFieldStyle(.automatic)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .padding()
            .minimumScaleFactor(0.1) //this does not seem to work for textfield
        }
    }
    
    func theName(i: Int) -> some View {
        ZStack() {
            Text(names[i] == "" ? "Player \(i+1)" : " ")
            TextField("Player \(i+1)", text: $names[i])
                .background(i < count ? .clear : .gray)
                .border(.yellow)
        }
    }
    
    func swapNames(i: Int, j: Int) {
        let temp = names[i]
        names[i] = names[j]
        names[j] = temp
    }
    
    func upButton(i: Int) -> some View {
        Image(systemName: Constants.image.up)
            .foregroundStyle(i > 0 ? PoolScorecardApp.Constants.symbolColor : .clear)
            .onTapGesture {
                if i > 0 {
                    swapNames(i: i, j: i-1)
                }
            }
    }
    
    func downButton(i: Int) -> some View {
        Image(systemName: Constants.image.down)
            .foregroundStyle(i < 5 ? PoolScorecardApp.Constants.symbolColor : .clear)
    }
    
    func popoverView(_ row: Int) -> some View {
        ForEach (names.filter({$0 != names[row] && $0 != ""}), id: \.self) { name in
            Button {
                //TODO: remove force unwrapping
                swapNames(i: row, j: names.firstIndex(of: name)!)
                showingPopover[row] = false
            } label: {
                Text("\(name)")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(20)
    }
    
    func swapButton(i: Int) -> some View {
        Image(systemName: Constants.image.move)
            .foregroundStyle( PoolScorecardApp.Constants.symbolColor)
            .onTapGesture {
                showingPopover[i].toggle()
            }
            .popover(isPresented: $showingPopover[i]) {
                popoverView(i)
            }
    }

    struct Constants {
        struct image {
            static let up = "arrowshape.up.circle.fill"
            static let down = "arrowshape.down.circle.fill"
            static let move = "arrow.up.and.line.horizontal.and.arrow.down"
        }
    }
    
    
}



#Preview {
    GetNewNames(names: .constant(["Test Name That is Really, Really, Really, Really Long", "Normal Player Name", "Test", "", "", "Bubba"]), count: 4)
}
