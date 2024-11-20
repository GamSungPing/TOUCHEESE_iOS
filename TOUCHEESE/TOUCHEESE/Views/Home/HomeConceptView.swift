//
//  HomeConceptView.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeConceptView: View {
    private let conceptCards: [ConceptCard] = [
        ConceptCard(imageString: "liveliness", concept: .liveliness),
        ConceptCard(imageString: "flashIdol", concept: .flashIdol),
        ConceptCard(imageString: "blackBlueActor", concept: .blackBlueActor),
        ConceptCard(imageString: "naturalPictorial", concept: .naturalPictorial),
        ConceptCard(imageString: "clarityDoll", concept: .clarityDoll),
        ConceptCard(imageString: "waterColor", concept: .waterColor)
    ]
    private let columns = [
        GridItem(.flexible(), spacing: -20),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(conceptCards) { conceptCard in
                NavigationLink(value: conceptCard) {
                    conceptCardView(conceptCard)
                }
            }
        }
        .navigationDestination(for: ConceptCard.self) { conceptCard in
            HomeResultView(concept: conceptCard.concept)
        }
        .navigationTitle("TOUCHEESE")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func conceptCardView(_ conceptCard: ConceptCard) -> some View {
        VStack {
            Image(conceptCard.imageString)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(conceptCard.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.vertical, 8)
        }
        .frame(width: 160, height: 200)
        .background(Color.white)
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
}
