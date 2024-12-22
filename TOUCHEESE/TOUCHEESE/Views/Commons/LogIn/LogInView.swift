//
//  LogInView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
    private let viewModel: LogInViewModel = LogInViewModel()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Image(.tcLoginLogo)
                    .padding(.bottom, 20)
                
                Text("나에게 딱 맞는 스튜디오를\n한 눈에 살펴보세요.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundStyle(.tcGray10)
                    .font(.pretendardBold(24))
                    .padding(.bottom, 10)
                
                Text("컨셉별 스튜디오를 확인 후 예약까지 간편하게!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.tcGray06)
                    .font(.pretendardRegular16)
                    .padding(.bottom, 30)
                
                VStack(spacing: 8) {
                    // TODO: - 카카오 로그인 버튼 추가
                    FillBottomButton(
                        isSelectable: true,
                        title: "카카오로 로그인(초안)"
                    ) {
                        print("카카오 로그인")
                    }
                    
                    SignInWithAppleButton { request in
                        request.requestedScopes = []
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Apple Authorization successful.")
                            viewModel.handleAuthorization(authResults)
                        case .failure(let error):
                            print("Apple Authorization failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 360, height: 48)
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // TODO: - 임시 X 버튼
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.6))
                        }
                }
                .padding(.leading, 20)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tcPrimary01.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LogInView(isPresented: .constant(true))
}
