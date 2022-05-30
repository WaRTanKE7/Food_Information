//
//  Home.swift
//  Food_Information
//
//  Created by E7 on 2022/5/24.
//

import SwiftUI



struct Home: View {
    @StateObject var homeVM: HomeVM = .init()
    
    var body: some View {
        Text("首頁")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}



//    .alert("GPS 定位權限", isPresented: $homeVM.noLocationAuthorization) {
//        Button {
//
//        } label: {
//            Text("OK")
//        }
//
//    } message: {
//        Text("GPS 權限不足，請至設定內更改權限")
//    }
