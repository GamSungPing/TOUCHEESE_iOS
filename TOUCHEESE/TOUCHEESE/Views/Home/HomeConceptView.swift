//
//  HomeConceptView.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeConceptView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    private let conceptCards: [ConceptCard] = [
        ConceptCard(imageString: "flashIdol", concept: .flashIdol),
        ConceptCard(imageString: "liveliness", concept: .liveliness),
        ConceptCard(imageString: "blackBlueActor", concept: .blackBlueActor),
        ConceptCard(imageString: "naturalPictorial", concept: .naturalPictorial),
        ConceptCard(imageString: "waterColor", concept: .waterColor),
        ConceptCard(imageString: "clarityDoll", concept: .gorgeous)
    ]
    private let columns = [
        GridItem(.flexible(), spacing: -20),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(conceptCards) { conceptCard in
                    Button {
                        navigationManager.goHomeResultView(material: HomeResultViewMaterial(concept: conceptCard.concept))
                    } label: {
                        conceptCardView(conceptCard)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .background(.tcLightyellow)
        .navigationTitle("TOUCHEESE")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func conceptCardView(_ conceptCard: ConceptCard) -> some View {
        VStack(spacing: 8) {
            Image(conceptCard.imageString)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(conceptCard.title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(width: 160, height: 190)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.6))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}


fileprivate struct ConceptCard: Identifiable, Hashable {
    let id: UUID = UUID()
    let imageString: String
    let concept: StudioConcept
    var title: String {
        concept.title
    }
}

#Preview {
    NavigationStack {
        HomeConceptView()
    }
    .environmentObject(StudioListViewModel())
    .environmentObject(NavigationManager())
}
