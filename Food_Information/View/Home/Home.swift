//
//  Home.swift
//  Food_Information
//
//  Created by E7 on 2022/5/24.
//

import SwiftUI



struct Home: View {
    @StateObject var homeVM: HomeVM = .init()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(1 ... 10, id: \.self) { _ in
                        card()
                    }
                }
                .padding()
            }
            .navigationTitle("附近餐廳")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    @ViewBuilder
    func card() -> some View {
        VStack(spacing: 5) {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.black)
                .cornerRadius(5)
                .frame(maxWidth: .infinity)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: 店名與收藏
                HStack {
                    Text("小吃店")
                        .font(.title2)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .padding(10)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                
                
                // MARK: 評價
                HStack(spacing: 15) {
                    Stars(rating: 4.5)
                        .padding(.leading, 7)
                    
                    Text("(100)")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                
                // MARK: 價格
                HStack(spacing: 0) {
                    ForEach(1..<5) { _ in
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                    }
                }
                
                // MARK: 距離
                Text("1.8 公里")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                // MARK: 營業狀況
                Text("營業中")
                    .font(.callout)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Rectangle().fill(Color.white))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 1)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
