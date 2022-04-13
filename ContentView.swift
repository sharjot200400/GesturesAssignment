//
//  ContentView.swift
//  gestures
//
//  Created by user216710 on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    @State var singleTap = true
    @State var doubleTap = true
    @State var longTap = true
    var people: [String] = ["Hello", "Sir", "This", "is", "my", "project", "Will", "you", "give", "me", "full", "marks"].reversed()
    var body: some View {
        VStack{
            Text("Single Tap Gesture")
                .padding()
                .foregroundColor(.black)
                .background(singleTap ? .green : .blue)
                .cornerRadius(  5)
                .onTapGesture {
                    singleTap.toggle()
                }
                .padding(.top, 100)
            Text("Double Tap Gesture")
                .padding()
                .foregroundColor(.black)
                .background(doubleTap ? .green : .blue)
                .cornerRadius(5)
                .onTapGesture(count: 2){
                    doubleTap.toggle()
                }
            Text("Long Press Gesture")
                .padding()
                .foregroundColor(.black)
                .background(longTap ? .green : .blue)
                .cornerRadius(  5)
                .onLongPressGesture(minimumDuration: 1.0) {
                    longTap.toggle()
                }
            VStack{
                ZStack{
                    ForEach(people, id: \.self){
                        person in CardView(person: person)
                    }
                }
            }
            .padding(.top, 10)
            Text("Swipe Gesture")
                .padding()
            NavigationView{
                        NavigationLink(destination: photos(), label: {
                    Text("Click to open images")
                        .padding()
                        .foregroundColor(.black)
                        .background(.green)
                        .cornerRadius(  5)
                        .padding(.top, -50)
                })
            }
                    }
    }
}

struct photos:View{
    @State var angle: Angle = Angle(degrees: 0)
    @State var currentAmount: CGFloat = 0
    var body: some View{
        HStack{
                Image("canadore")
                .rotationEffect(angle)
                .scaleEffect(1 + currentAmount)
                .gesture(
                RotationGesture()
                    .onChanged{
                        value in angle = value
                    }
                    .onEnded{
                        value in withAnimation(.spring()){
                            angle = Angle(degrees: 0)
                        }
                    }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged{
                            value in currentAmount = value - 1
                        }
                )
        }
        
    }
}

struct CardView: View {
    @State private var offset = CGSize.zero
    @State private var color: Color = .black
    var person: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .border(.white, width: 6.0)
                .cornerRadius(4)
                .foregroundColor(color.opacity(0.9))
                .shadow(radius: 4)
            HStack {
                Text(person)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
            }
            
        }
        .offset(x: offset.width * 1, y: offset.height * 0.4)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                }
        )
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(person) removed")
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(person) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .black
        }
    }
    
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(person: "Mario")
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}

