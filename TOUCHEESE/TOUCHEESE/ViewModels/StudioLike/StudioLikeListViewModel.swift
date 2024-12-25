//
//  StudioLikeListViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/26/24.
//

import Foundation

final class StudioLikeListViewModel: ObservableObject {
    
    @Published private(set) var likedStudios: [Studio] = []
    
}
