//
//  ButtonView.swift
//  PomodoroIOS
//
//  Created by Seyit Murat Kaya on 18.02.2022.
//

import SwiftUI

struct ButtonView: View {
    var text:String
    var function: () -> Void
    var body: some View {
        Button {
            self.function()
        } label: {
            Text(text)
        }
        .padding()
        .foregroundColor(.white)
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "", function: {})
    }
}
