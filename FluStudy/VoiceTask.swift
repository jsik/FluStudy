//
//  VoiceTask.swift
//  FluStudy
//
//  Created by Jean Sik on 2017/10/25.
//  Copyright © 2017 Jean Sik. All rights reserved.
//

import UIKit
import ResearchKit

public var VoiceTask: ORKOrderedTask
{
    let intendedUseDescription = "Everyone's voice has unique characteristics."
    let speechInstruction = "After the countdown, start coughing for as long as you can. You'll have 10 seconds."
    let shortSpeechInstruction = "Start coughing for as long as you can."
    
    return ORKOrderedTask.audioTask(withIdentifier: "VoiceTask", intendedUseDescription: intendedUseDescription, speechInstruction: speechInstruction, shortSpeechInstruction: shortSpeechInstruction, duration: 5, recordingSettings: nil, checkAudioLevel: false, options: ORKPredefinedTaskOption.excludeAccelerometer)
}
