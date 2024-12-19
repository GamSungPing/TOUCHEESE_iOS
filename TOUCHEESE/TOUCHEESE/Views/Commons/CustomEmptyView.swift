//
//  CustomEmptyView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/18/24.
//

import SwiftUI

struct CustomEmptyView: View {
    let viewType: ViewType
    
    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            
            Image(.tcEmptyIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 84)
                .foregroundStyle(.tcGray03)
            
            Text("\(viewType.description)")
                .font(.pretendardMedium(18))
                .foregroundStyle(.tcGray04)
            
            switch viewType {
            case .studio(let action, let text):
                Text("\(text)")
                    .foregroundStyle(.tcPrimary06)
                    .font(.pretendardMedium18)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.tcPrimary06, lineWidth: 1)
                    }
                    .onTapGesture {
                        action()
                    }
            default:
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
    }
    
    enum ViewType {
        case studio(buttonAction: () -> Void, buttonText: String)
        case review
        case reservation
        case pastReservation
        
        var description: String {
            switch self {
            case .studio:
                return "해당하는 스튜디오가 없습니다."
            case .review:
                return "작성된 리뷰가 없습니다."
            case .reservation:
                return "예약 내역이 없습니다."
            case .pastReservation:
                return "이전 내역이 없습니다."
            }
        }
    }
}

#Preview {
    CustomEmptyView(
        viewType: .studio(buttonAction: {print("헬로")}, buttonText: "필터 초기화 하기")
    )
}