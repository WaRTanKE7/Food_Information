//
//  Stars.swift
//  Food_Information
//
//  Created by E7 on 2022/5/30.
//

import SwiftUI

struct Stars: View {
    private static let MAX_RATING: Float = 5
    private static let COLOR = Color.orange
    
    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int

    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(Stars.MAX_RATING - rating)
        halfFullCount = (Float(fullCount + emptyCount) < Stars.MAX_RATING) ? 1 : 0
    }
    
    var body: some View {
        HStack(spacing: 17) {
            ForEach(0..<fullCount, id: \.self) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount, id: \.self) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount, id: \.self) { _ in
                self.emptyStar
            }
        }
    }
    
    private var fullStar: some View {
        Image(systemName: "star.fill")
            .foregroundColor(Stars.COLOR.opacity(0.7))
            .frame(width: 3, height: 3)
    }

    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill")
          .foregroundColor(Stars.COLOR.opacity(0.7))
          .frame(width: 3, height: 3)
    }

    private var emptyStar: some View {
        Image(systemName: "star")
          .foregroundColor(Stars.COLOR.opacity(0.7))
          .frame(width: 3, height: 3)
    }
}
