//
//  ViewController.swift
//  Xylophone
//
//  Created by Rafael Asencio on 23/02/2019.
//  Copyright © 2019 Rafael Asencio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet  var bntNotes: [UIButton]!

    
    var audioPlayer: AVAudioPlayer!
    let xylophoneTonesArray = ["note1","note2","note3","note4","note5","note6","note7"]
    var notesPressed  : [String] = []
    var arrayToCompare : [String] = []
    var clickCounter = 0
    var randomArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clean(_ sender: UIButton) {
        notesPressed = []
    }
    
    @IBAction func start(_ sender: UIButton) {
        arrayToCompare = []
        // Crear random notes array
        randomArray = [String]()
        
        for _ in 1...1 {
            let randomElement = xylophoneTonesArray.randomElement() ?? ""
            randomArray.append(randomElement)
        }
        
        print(randomArray)
        
        // reproducirlo
        var time: Double = 0
        randomArray.forEach({ note in
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                self.playSound(selectedSoundFileName: note)
                self.selectNoteAnimation(selectedSoundFileName: note)
            })
            time += 1
        })
        
    }
//    si la primera nota del sender == primera nota del randomArray continue
    @IBAction func notePressed(_ sender: UIButton) {
        let buttonIndex = sender.tag - 1
        guard xylophoneTonesArray.count > buttonIndex else { return }
        let element = xylophoneTonesArray[buttonIndex]
        
       selectNoteAnimation(selectedSoundFileName: element)
        playSound(selectedSoundFileName: element)
        
        arrayToCompare.append(xylophoneTonesArray[sender.tag - 1])
        notesPressed.append(element)
        
        if (randomArray.count == arrayToCompare.count) {
            if (randomArray == notesPressed) {
                clickCounter += 1
               counter.text = "\(clickCounter)"
                success()
                arrayToCompare = []
                notesPressed = []
            } else {
                print("Error")
                reStart()
                counter.text = "\(0)"
            }
        }

        print("array aleatorio: ", randomArray)
        print("array que tiene que ser igual: ", arrayToCompare)
        print("nota pulsada: ", notesPressed)
    }
    
    
    func selectNoteAnimation(selectedSoundFileName: String) {
        // Add border
        var buttonIndex = 0
        for i in 0...xylophoneTonesArray.count - 1 {
            let note = xylophoneTonesArray[i]
            if note == selectedSoundFileName {
                buttonIndex = i
                break
            }
        }
        
        let button = bntNotes[buttonIndex]
        DispatchQueue.main.async {
            button.alpha = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            button.alpha = 1.0
        })
    }
    
    func playSound(selectedSoundFileName: String) {
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
        
        audioPlayer.play()
    }
    
    func success() {
        let alertController = UIAlertController(title: "Felicidades!", message: "Has desbloqueado el siguiente nivel", preferredStyle: .alert)
        
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//        }
        
        let nextLevel = UIAlertAction(title: "Next Level", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Next Level Pressed")
            
            for _ in 1...1 {
                let randomElement = self.xylophoneTonesArray.randomElement() ?? ""
                self.randomArray.append(randomElement)
            }
            
//            print(self.randomArray)
            
            // reproducirlo
            var time: Double = 0
            self.randomArray.forEach({ note in
                DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                    self.playSound(selectedSoundFileName: note)
                    self.selectNoteAnimation(selectedSoundFileName: note)
                })
                time += 1
            })
        }
//        alertController.addAction(okAction)
        alertController.addAction(nextLevel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reStart() {
        let alertController = UIAlertController(title: "Ups!", message: "La proxima vez será", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.arrayToCompare = []
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
