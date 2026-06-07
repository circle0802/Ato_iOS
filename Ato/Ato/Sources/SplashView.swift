//
//  ContentView.swift
//  Ato
//
//  Created by hawon on 5/31/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Spacer()
        VStack {
            Text("아토")
                .font(.ato(.semiBold, 40))
                .foregroundStyle(Color.orange400)
            Text("소중한 사람에게 소중함을")
                .font(.ato(.regular, 20))
                .foregroundStyle(Color.gray100)
        }
        Spacer()
        NavigationLink {
            LoginView()
                .navigationBarBackButtonHidden(true)
        } label: {
            Text("선물고르러 가기")
                .font(.ato(.semiBold, 16))
                .foregroundStyle(Color.orange400)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color.orange100)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SplashView()
}
