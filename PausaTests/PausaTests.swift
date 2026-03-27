//
//  PausaTests.swift
//  PausaTests
//
//  Created by Jimmy Ronaldo Macedo Pizango on 20/03/26.
//

import XCTest
@testable import Pausa

final class PausaTests: XCTestCase {

    func testExercisesIncludeEvidenceAndContext() {
        XCTAssertFalse(ExerciseLibrary.all.isEmpty)

        for exercise in ExerciseLibrary.all {
            XCTAssertFalse(exercise.evidenceSummary.isEmpty, "Falta respaldo en \(exercise.id)")
            XCTAssertFalse(exercise.originStory.isEmpty, "Falta contexto en \(exercise.id)")
            if exercise.evidenceLevel == .investigado {
                XCTAssertFalse(exercise.references.isEmpty, "Faltan fuentes en \(exercise.id)")
            }
        }
    }

    func testRecommendationForAnxietyUsesResearchBackedBreathingExercise() {
        let recommendation = RecommendationEngine().recommendation(for: .ansioso, stressLevel: 8)

        guard case .exercise(let exercise) = recommendation.route else {
            return XCTFail("La recomendación ansiosa debería abrir un ejercicio")
        }

        XCTAssertEqual(exercise.id, "breathing-444")
        XCTAssertEqual(exercise.evidenceLevel, .investigado)
    }

    func testGroundingIsMarkedAsComplementarySupport() {
        let grounding = ExerciseLibrary.by(id: "grounding")

        XCTAssertEqual(grounding?.evidenceLevel, .complementario)
    }
}
