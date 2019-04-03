//
//  ViewController.swift
//  TimerApp
//
//  Created by Devon Dodgson on 3/25/19.
//  Copyright © 2019 Devon Dodgson. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    
    var timerOn = false
    var currentTime = 0
    var timer = Timer()
    var alarmSound : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.text = String("00:00")
        //Somehting
    }
    
    @IBAction func setTimer(_ sender: UITapGestureRecognizer) {
//        presentAlert()
        if timerOn == false && currentTime == 0 {
            presentAlertTwo()
        } else {
            pauseTimer()
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetTimer()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        if timerOn == false && currentTime > 0 {
            updatePauseUI()
            runTimer()
        } else if currentTime > 0 {
            pauseTimer()
        } else {
            presentAlertTwo()
        }
        
    }
    
    //Handles PAUSE feature
    func pauseTimer() {

        timer.invalidate()
        updateStartUI()
        
    }
    
    func updateTime() {
        
        
        
    }
    
    func presentAlertTwo() {
        
        let alert = UIAlertController(title: "Timer Length", message: "Please enter desired timer length", preferredStyle: .alert)
        
        if timerOn == false {
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter total minutes"
            }
        
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("Cancelled")
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            let prefferedTime = alert.textFields?.first?.text
            self.chosenTime(timerLength: Int(prefferedTime!) ?? 30)
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }

    //Handles Alert for sender to choose timer length.
//    func presentAlert() {
//
//        let alert = UIAlertController(title: "Timer Length", message: "Please choose timer length:", preferredStyle: .alert)
//
//        if timerOn == false {
//
//            alert.addAction(UIAlertAction(title: "Test", style: .default, handler: { (UIAlertAction) in
//                self.chosenTime(timerLength: 1)
//            }))
//
//            alert.addAction(UIAlertAction(title: "30min", style: .default, handler: { (UIAlertAction) in
//                self.chosenTime(timerLength: 30)
//            }))
//            alert.addAction(UIAlertAction(title: "45min", style: .default, handler: { (UIAlertAction) in
//                self.chosenTime(timerLength: 45)
//            }))
//            alert.addAction(UIAlertAction(title: "60min", style: .default, handler: { (UIAlertAction) in
//                self.chosenTime(timerLength: 60)
//            }))
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
//                alert.dismiss(animated: true, completion: {
//                    print("Cancelled")
//                })
//            }))
//
//            present(alert, animated: true, completion: nil)
//
//        }
//
//    }
    
    //Updates UILabel to display sender minute selection in seconds
    func chosenTime(timerLength: Int) {
        
        currentTime = timerLength * 60
        timerLabel.text = String(currentTime)
        formatTime()
        
    }
    
    //Sets timer length to sender's chosen timer from alert.
    func formatTime() {

        let minutes = currentTime / 60 % 60
        let seconds = currentTime % 60
        let format = String(format:"%02i:%02i", minutes, seconds)

        self.timerLabel.text = format
    }
    
    //Updates Start/Pause button to "PAUSE" state (text/color changes)
    func updatePauseUI() {
        timerOn = true
        startPauseButton.backgroundColor = UIColor(red: 0.3608, green: 0.2863, blue: 0.4706, alpha: 1.0)
        startPauseButton.setTitle("PAUSE", for: .normal)
    }
    
    //Updates Start/Pause button to "START" state (text/color changes)
    func updateStartUI() {
        timerOn = false
        startPauseButton.backgroundColor = UIColor(red: 0, green: 0.7647, blue: 1, alpha: 1.0) /* #00c3ff */
        startPauseButton.setTitle("START", for: .normal)
    }
    
    //Reset feature
    func resetTimer() {
        timer.invalidate()
        timerOn = false
        timerLabel.text = String("00:00")
        updateStartUI()
    }
    
    //Handles Running timer
    func runTimer() {
            
            if timerLabel.text != "00:00" {
                
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats:true, block: { (timer) in
                        self.currentTime -= 1
                        self.formatTime()
                        
                        if self.currentTime == 0 {
                            self.playSound()
                            self.resetTimer()
                        }
                    })

            }
    }
    
    func playSound() {
        
        let soundURL = Bundle.main.url(forResource: "alarmSound", withExtension: "m4a")
        
        do {
            alarmSound = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print("Cannot locate file \(error)!")
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        alarmSound.play()
    }
}

