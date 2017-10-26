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
    var taskViewController:ORKTaskViewController!
    
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
        consentTaskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
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
                writeResultToFile(taskViewController: consentTaskViewController, type: "consent")
                print("done with consent form!")
                
                taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
                taskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
                taskViewController.delegate = self
                present(taskViewController, animated: true, completion: nil)
            }
            else
            {
                //writeResultToFile(taskViewController: voiceTaskViewController, type:)
                print("Done with tapping form")
            }
            
        }
    }
    
    func writeResultToFile(taskViewController: ORKTaskViewController, type:String)
    {
        let path = consentTaskViewController.outputDirectory
        let fileString = "\((path?.path)!)/\(type)-data.obj"
        let success = NSKeyedArchiver.archiveRootObject(taskViewController.result, toFile: fileString)
        print("file write success \(success)")
    }
    
    
    
    
    
}
