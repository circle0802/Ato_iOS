//
//  ContentView.swift
//  Ato
//
//  Created by hawon on 5/31/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("안녕하세요")
                .font(.ato(.regular, 20))
        }
        .padding()
    }
}

#Preview {
    SplashView()
}
