//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail = StudioDetail.sample
    
    init(studio: Studio) {
        self.studio = studio
    }
    
}
