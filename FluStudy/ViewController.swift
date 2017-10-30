//
//  ViewController.swift
//  FluStudy
//
//  Created by Jean Sik on 2017/10/25.
//  Copyright © 2017 Jean Sik. All rights reserved.
//

import UIKit
import ResearchKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVPlayerViewControllerDelegate {

    var consentTaskViewController:ORKTaskViewController!
    var surveyTaskViewController:ORKTaskViewController!
    var voiceTaskViewController:ORKTaskViewController!
    @IBOutlet weak var firstVideo: UIImageView?
    @IBOutlet weak var secondVideo: UIImageView?
    @IBOutlet weak var thirdVideo: UIImageView?
    var urls = [
        "https://www.cdc.gov/flu/video/flushots_30sec.mp4",
        "https://www.cdc.gov/flu/video/inever_60sec.mp4",
        "https://www.cdc.gov/flu/video/who-needs-flu-vaccine-15_320px.mp4"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let url1 = URL(string: urls[0])
        if let thumbnailImage1 = getThumbnailFrom(path: url1!) {
            firstVideo?.image = thumbnailImage1
            firstVideo?.layoutIfNeeded()
        }
        let url2 = URL(string: urls[1])
        if let thumbnailImage2 = getThumbnailFrom(path: url2!) {
            secondVideo?.image = thumbnailImage2
            secondVideo?.layoutIfNeeded()
        }
        let url3 = URL(string: urls[2])
        if let thumbnailImage3 = getThumbnailFrom(path: url3!) {
            thirdVideo?.image = thumbnailImage3
            thirdVideo?.layoutIfNeeded()
        }
    }

    @IBAction func firstVideoBtnPressed(_ sender: Any) {
        self.playVideo(url: urls[0])
    }
    @IBAction func secondVideoBtnPressed(_ sender: Any) {
        self.playVideo(url: urls[1])
    }
    @IBAction func thirdVideoBtnPressed(_ sender: Any) {
        self.playVideo(url: urls[2])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func startResearchBtnPressed(_ sender: Any) {
        consentTaskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        consentTaskViewController.delegate = self
        present(consentTaskViewController, animated: true, completion: nil)
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(10, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            print(thumbnail)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    func playVideo(url: String) {
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            present(playerViewController, animated: true)
            {
                completionHandler(false)
            }
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
                surveyTaskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
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
                    let path = surveyTaskViewController.outputDirectory
                    let fileString = "\((path?.path)!)/\(type)-data.txt"
                    NSKeyedArchiver.archiveRootObject(taskResult as ORKTaskResult, toFile: fileString)
                    print(fileString)
                    break
                case "microphone":
                    let path = voiceTaskViewController.outputDirectory
                    let fileString = "\((path?.path)!)/\(type)-data.obj"
                    NSKeyedArchiver.archiveRootObject(taskResult, toFile: fileString)
                    print(fileString)
                    break
                default:
                    break
            }
            print("file write success")
        }
    }
    
    
    
    
    
}
