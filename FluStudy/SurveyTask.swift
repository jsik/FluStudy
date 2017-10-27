//
//  SurveyTask.swift
//  FluStudy
//
//  Created by Jean Sik on 2017/10/26.
//  Copyright © 2017 Jean Sik. All rights reserved.
//

import UIKit
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Introduction"
    instructionStep.text = "Please answer the following questions"
    steps += [instructionStep]

    
    let firstStepFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5,step: 1, vertical: false, maximumValueDescription: "Very bad", minimumValueDescription: "Very good")
    let firstStep = ORKQuestionStep(identifier: "firstStep", title: "How do you feel today?", answer: firstStepFormat)
    steps += [firstStep]
    
    let secondStepFormat = ORKNumericAnswerFormat(style:.integer)
    let secondStep = ORKQuestionStep(identifier: "secondStep", title: "What is your current temperature?", answer: secondStepFormat)
    steps += [secondStep]
    
    let thirdStepFormat = ORKBooleanAnswerFormat()
    let thirdStep = ORKQuestionStep(identifier: "thirdStep", title: "Do you have a runny nose?", answer: thirdStepFormat)
    steps += [thirdStep]
    
    let fourthStepFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5,step: 1, vertical: false, maximumValueDescription: "Hurts worst", minimumValueDescription: "No hurt")
    let fourthStep = ORKQuestionStep(identifier: "fourthStep", title: "How sore/achey is your body today?", answer: fourthStepFormat)
    steps += [fourthStep]
    
    let fifthStepFormat = ORKBooleanAnswerFormat()
    let fifthStep = ORKQuestionStep(identifier: "fifthStep", title: "Have you had flu shot this year?", answer: fifthStepFormat)
    steps += [fifthStep]
    
    let sixthStepFormat = ORKBooleanAnswerFormat()
    let sixthStep = ORKQuestionStep(identifier: "sixthStep", title: "Does anyone else have flu in your family?", answer: sixthStepFormat)
    steps += [sixthStep]
    
//    let countdownStep = ORKCountdownStep(identifier: "CountdownStep")
//    countdownStep.stepDuration = 5
//    countdownStep.title = "Get ready to record your cough"
//    countdownStep.text = "After the countdown, start coughing for as long as you can. You'll have 10 seconds."
//    steps += [countdownStep]
    
//    let seventhStep = ORKAudioStep(identifier: "seventhStep")
//    seventhStep.title = "Record your cough"
//    seventhStep.text = "Please cough for as long as you can."
//    seventhStep.stepDuration = 5
//    seventhStep.shouldContinueOnFinish = false;
//    let recordingSettings = [
//        AVSampleRateKey : 44100.0,
//        AVFormatIDKey : kAudioFormatAppleLossless,
//        AVNumberOfChannelsKey : 1,
//        AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue,
//        AVEncoderBitRateKey : 320000
//        ] as [String : Any]
//    let config = ORKAudioRecorderConfiguration(identifier: "Recorder", recorderSettings: recordingSettings)
//    seventhStep.recorderConfigurations?.append(config)
//    steps += [seventhStep]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Completed"
    summaryStep.text = "Thanks a lot for your participation. Take care!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
