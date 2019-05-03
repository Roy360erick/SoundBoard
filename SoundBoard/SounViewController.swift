//
//  SounViewController.swift
//  SoundBoard
//
//  Created by Erick Fernandez  on 30/04/19.
//  Copyright © 2019 Erick Fernandez . All rights reserved.
//

import UIKit
import AVFoundation

class SounViewController: UIViewController {

    

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder();
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder(){
        
        do{
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
            let pathComponents = [basePath,"audio.m4a"]
             audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("***************************")
            print(audioURL!)
            print("***************************")
            
            var settings : [String : AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings : settings)
            audioRecorder!.prepareToRecord()
            
        }catch let error as NSError {
            print(error)
        }
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording{
            //Detener la grabacion
            audioRecorder?.stop();
            //Cambiar el texto del boton grabar
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            //empezar a grabar
            audioRecorder?.record()
            //Cambiar el titilo del boton a detener
            recordButton.setTitle("Stop", for: .normal)
            
        }
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf : audioURL!)
            audioPlayer!.play()
        }
        catch {}
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context : context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf : audioURL! as URL) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    

}
