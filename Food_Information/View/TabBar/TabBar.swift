//
//  TabBar.swift
//  Food_Information
//
//  Created by E7 on 2022/5/30.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Search = "magnifyingglass"
    case Home = "house.fill"
    case Favorite = "bookmark.fill"
    case Acount = "person.fill"
}

struct TabBar: View {
    @StateObject var tabBarVM: TabBarVM = .init()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State var currentTab: Tab = .Home
    @State private var currentXValue: CGFloat = 0
    
    @Namespace var animation
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            Text("搜尋")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea())
                .tag(Tab.Search)
            
            Home().body
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea())
                .tag(Tab.Home)
            
            Text("我的收藏")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea())
                .tag(Tab.Favorite)
            
            Text("個人")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea())
                .tag(Tab.Acount)
        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
            }
            .padding(.vertical)
            // 全螢幕手機 SafeArea Bottom != 0 要減少，以免 TabBar 使用太多空間
            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
            .background(
                MaterialEffect(style: .systemUltraThinMaterialLight)
                    .clipShape(BottomCurve(currentXValue: currentXValue))
            )
            ,alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.light) // Always light
        .onAppear {
            tabBarVM.checkLocationAuthorization()
        }
        .alert("GPS 定位權限", isPresented: $tabBarVM.noLocationAuthorization) {
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            } label: {
                Text("OK")
            }

        } message: {
            Text("GPS 權限不足，請至設定內更改權限\n 路徑：隱私權 -> 定位服務 -> Food_Information")
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
                Image(systemName: tab.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(currentTab == tab ? .white : .black)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack {
                            if currentTab == tab {
                                MaterialEffect(style: .systemUltraThinMaterialDark)
                                    .clipShape(Circle())
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
