//
//  ConsentDocument.swift
//  ResearchKitExample
//
//  Created by Teacher on 9/25/17.
//  Copyright © 2017 Teacher. All rights reserved.
//

import UIKit
import ResearchKit

public var ConsentDocument : ORKConsentDocument
{
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Consent for My Super Study!"
    
    let contentSectionTypes:[ORKConsentSectionType] = [.overview, .dataGathering, .privacy]
    
    let contentSections: [ORKConsentSection] = contentSectionTypes.map
    {
        contentSectionType in
        let contentSection = ORKConsentSection(type: contentSectionType)
        contentSection.summary = "Put a summary here!"
        contentSection.content = "Put some content here about this section!"
        return contentSection
    }
    
    consentDocument.sections = contentSections
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))

    return consentDocument
}
