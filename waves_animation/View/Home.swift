//
//  Home.swift
//  waves_animation
//
//  Created by Enrique Sotomayor on 10/9/21.
//

import SwiftUI

struct Home: View {
    @State private var toggle: Bool = false
    
    var body: some View {
        ZStack {
//            Wave form view
            WaveForm(color: .cyan.opacity(0.8), amplify: CGFloat(150), isReversed: false)
            WaveForm(color: (toggle ? Color.purple : Color.cyan).opacity(0.5), amplify: CGFloat(140), isReversed: true)
            
            VStack {
                HStack {
                    Text("Wave's")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Toggle(isOn: $toggle) {
                        Image(systemName: "eyedropper.halffull")
                            .font(.title2)
                        
                    }
                    .toggleStyle(.button)
                    .tint(.purple)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)

        }
        .ignoresSafeArea()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct WaveForm: View {
    
    var color: Color
    var amplify: CGFloat
    
    // reverse
    var isReversed: Bool
    
    var body: some View {
        // using time line view for periodic updates
        TimelineView(.animation) { timeline in

            // canvas view for drawing wave
            Canvas{context, size in
                // get current time
                let timeNow = timeline.date.timeIntervalSinceReferenceDate
                
                // moving the whole view
                let angle = timeNow.remainder(dividingBy: 2)
                
                // calc. offset
                let offset = angle * size.width
                // move whole view
                context.translateBy(x: isReversed ? -offset : offset, y: 0)
                    
                // using swiftUI path for drawing wave...
                context.fill(getPath(size: size), with: .color(color))
                // drawing curve front and back
                // so that translation will look like wave motion
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                
                context.translateBy(x: size.width * 2, y: 0)
                
                context.fill(getPath(size: size), with: .color(color))
            }
        }
    }
    
    func getPath(size: CGSize) -> Path {
        return Path{ path in
            let midHeight = size.height / 2
            let width = size.width
            // moving the wave to center leading ...
            path.move(to: CGPoint(x: 0, y: midHeight))
            
            // drawing curve...
            path.addCurve(
                to: CGPoint(x: width, y: midHeight),
                control1: CGPoint(x: width * 0.4, y: midHeight + amplify),
                control2: CGPoint(x: width * 0.65, y: midHeight - amplify))
            
            // fill bottom with remaining area...
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            
        }
    }
}
