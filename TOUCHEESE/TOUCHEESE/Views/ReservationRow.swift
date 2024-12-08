//
//  ReservationRow.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ProfileImageView(imageURL: .defaultImageURL, size: 40)
            
            VStack(alignment: .leading) {
                Text("시현하다-강남 오리지널")
                    .fontWeight(.bold)
                
                Label("2024-12-8 (일)", systemImage: "calendar")
                
                Label("11:00~12:00", systemImage: "clock")
            }
            
            Spacer()
            
            Text("예약 대기")
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.tcLightgray)
                }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.tcLightyellow)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    ReservationRow()
}
