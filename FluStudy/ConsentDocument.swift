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
    consentDocument.title = "Research Flu Study Consent Form"
    
    let contentSectionTypes:[ORKConsentSectionType] = [.overview, .dataGathering, .privacy]
    let ipsum = [
        "Vivamus laoreet erat sit amet tincidunt scelerisque. Maecenas odio sapien, molestie eu vulputate sodales, tincidunt at neque. Nunc venenatis velit et ligula dictum, eget accumsan felis consectetur. Donec scelerisque fermentum vestibulum. Nam molestie finibus mauris, id congue lectus ultrices eu. Nunc et odio vitae dui interdum dictum. Proin sagittis leo quam. Proin vulputate massa ac orci pulvinar, eget rhoncus urna congue. Sed ut vehicula tellus, eget scelerisque enim. Cras lobortis diam at faucibus scelerisque. Curabitur pharetra arcu erat, nec tincidunt mi eleifend ut. Nunc suscipit risus vitae consectetur sodales. Aenean vitae lectus odio. Phasellus diam orci, accumsan non elementum at, finibus condimentum mauris. Nullam est enim, rhoncus a rutrum sed, laoreet a magna.",
        "Duis euismod sollicitudin elementum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed at pharetra sapien. Pellentesque cursus laoreet interdum. Nunc mi sapien, congue vel eleifend in, luctus sit amet massa. Nam tempus metus nec mauris bibendum, vel suscipit quam aliquet. Vestibulum sagittis mi et tempus iaculis. Integer varius eros non sagittis elementum. Proin dictum magna sit amet nulla volutpat posuere eget ac mi. Cras aliquam tristique velit nec porttitor. Integer nulla ligula, vestibulum a ullamcorper non, volutpat non nibh. Integer auctor ipsum id leo pharetra, vitae dapibus augue sagittis. Proin ut diam non orci vulputate rutrum a et nulla. Maecenas in varius augue, eu pretium metus. In auctor ornare augue ac sodales.",
        "Aenean in ligula quis arcu rhoncus tristique. Donec ut nisl suscipit augue ornare venenatis. Suspendisse commodo nibh dignissim, congue justo quis, ultrices sapien. Aliquam at lacinia ante. Sed venenatis quam eget dui lobortis, non ullamcorper tellus molestie. Quisque tempus fringilla velit, et viverra odio accumsan quis. Suspendisse potenti. Nullam ac dolor nunc. Pellentesque nec scelerisque risus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus consectetur efficitur rutrum. Suspendisse in arcu id ex luctus aliquam quis at quam."
    ]
    let contentSections: [ORKConsentSection] = contentSectionTypes.map
    {
        contentSectionType in let contentSection = ORKConsentSection(type: contentSectionType)
        let localizedIpsum = NSLocalizedString(ipsum[contentSectionTypes.index(of: contentSectionType)!], comment: "")
        let localizedSummary = localizedIpsum.components(separatedBy: ".")[0] + "."
        contentSection.summary = localizedSummary
        contentSection.content = localizedIpsum
        return contentSection
    }
    
    consentDocument.sections = contentSections
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))

    return consentDocument
}
