//
//  TabBar.swift
//  Food_Information
//
//  Created by E7 on 2022/5/30.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Search = "搜尋"
    case Home = "首頁"
    case Favorite = "收藏"
    case Acount = "個人"
}

struct TabBar: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State var currentTab: Tab = .Home
    @State private var currentXValue: CGFloat = 0
    
    @StateObject private var locationManager = LocationManager()
    
    @Namespace var animation
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            Text("搜尋")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Search)
            
            Home(location: $locationManager.location).body
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Home)
            
            Text("我的收藏")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Favorite)
            
            Text("個人")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Acount)
        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                        .overlay {
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                                .offset(y: currentTab == tab ? 15 : 100)
                        }
                }
            }
            .padding(.vertical)
            // 全螢幕手機 SafeArea Bottom != 0 要減少，以免 TabBar 使用太多空間
            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
            .background(
                Color
                    .white
                    .clipShape(BottomCurve(currentXValue: currentXValue))
            )
            ,alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.light) // Always light
        .onAppear {
            locationManager.checkIfLocationServicesIsEnable()
        }
    }
    
    // MARK: TabButton
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                Image(tab.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(currentTab == tab ? .white : .gray)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack {
                            if currentTab == tab {
                                Circle()
                                    .fill(Color("orange"))
                                    .shadow(color: Color.gray.opacity(0.8), radius: 8, x: 0, y: 10)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            .onAppear {
                if tab == .Home && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
