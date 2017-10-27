//
//  ViewController.swift
//  FluStudy
//
//  Created by Jean Sik on 2017/10/25.
//  Copyright © 2017 Jean Sik. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {

    var consentTaskViewController:ORKTaskViewController!
    var surveyTaskViewController:ORKTaskViewController!
    var voiceTaskViewController:ORKTaskViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startResearchBtnPressed(_ sender: Any) {
        consentTaskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        //consentTaskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
        consentTaskViewController.delegate = self
        present(consentTaskViewController, animated: true, completion: nil)
    }


}

extension ViewController : ORKTaskViewControllerDelegate
{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?)
    {
        dismiss(animated: true, completion: nil)
        
        if reason != ORKTaskViewControllerFinishReason.discarded
        {
            
            if consentTaskViewController == taskViewController
            {
                
                writeResultToFile(taskViewController: consentTaskViewController, type: "consent", reason: reason)
                print("done with consent form!")
                
                surveyTaskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
                //surveyTaskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
                surveyTaskViewController.delegate = self
                present(surveyTaskViewController, animated: true, completion: nil)
            } else if surveyTaskViewController == taskViewController
            {
                writeResultToFile(taskViewController: surveyTaskViewController, type: "survey", reason: reason)
                print("done with survey!")
                
                voiceTaskViewController = ORKTaskViewController(task: VoiceTask, taskRun: nil)
                voiceTaskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
                voiceTaskViewController.delegate = self
                present(voiceTaskViewController, animated: true, completion: nil)
            }
            else
            {
                writeResultToFile(taskViewController: voiceTaskViewController, type: "microphone", reason: reason)
                print("done with voice!")
            }
            
        }
    }
    
    func writeResultToFile(taskViewController: ORKTaskViewController, type:String, reason: ORKTaskViewControllerFinishReason)
    {
        let taskResult = taskViewController.result
        if reason == ORKTaskViewControllerFinishReason.completed
        {
            switch(type) {
                case "consent":
                    let signatureResult : ORKConsentSignatureResult = taskResult.stepResult(forStepIdentifier: "ConsentReviewStep")?.firstResult as! ORKConsentSignatureResult
                    let document = ConsentDocument.copy() as! ORKConsentDocument
                    signatureResult.apply(to: document)
                    document.makePDF(completionHandler: { (pdfData:Data?, error: Error?) in
                        var path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
                        path.appendPathComponent("\(type)-data.pdf")
                        print(path)
                        do {
                            try pdfData?.write(to:path)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    })
                    break
                case "survey":
                    let document = ConsentDocument.copy() as! ORKConsentDocument
                    document.makePDF(completionHandler: { (pdfData:Data?, error: Error?) in
                        var path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
                        path.appendPathComponent("\(type)-data.pdf")
                        print(path)
                        do {
                            try pdfData?.write(to:path)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    })
                    break
                case "microphone":
                    break
                default:
                    break
            }
            
        }
        print("file write success")
    }
    
    
    
    
    
}
