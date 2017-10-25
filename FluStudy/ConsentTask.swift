//
//  ConsentTask.swift
//  ResearchKitExample
//
//  Created by Teacher on 9/25/17.
//  Copyright © 2017 Teacher. All rights reserved.
//

import UIKit
import ResearchKit

public var ConsentTask: ORKOrderedTask
{
    var steps = [ORKStep]()
    
    let consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    let signature = consentDocument.signatures!.first
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
    
    reviewConsentStep.text = "Review your consent agreement!"
    reviewConsentStep.reasonForConsent = "Please consent to your participation in our study!"
    
    steps += [reviewConsentStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)

}
