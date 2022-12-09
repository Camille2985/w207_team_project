//
//  ViewController.swift
//  second_sight
//
//  Created by Camille Church on 12/4/22.
//
import Vision
import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var imageView2: UIImageView!
    let synthesizer = AVSpeechSynthesizer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .systemGray4
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var prediction: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView2.backgroundColor = .secondarySystemBackground
        button.backgroundColor = .systemBlue
        button.setTitle("Take Picture",
                        for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let utterance = AVSpeechUtterance(string: "Application is ready for use")
        let utterance2 = AVSpeechUtterance(string: "Press the blue button on the bottom of the screen to begin")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1.0
        utterance2.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance2.rate = 0.5
        utterance2.volume = 1.0
        self.synthesizer.speak(utterance)
        self.synthesizer.speak(utterance2)
        
    }
    
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func tapFunction() {
        // what make siri say the text label
        let utterance = AVSpeechUtterance(string: prediction)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1.0
        self.synthesizer.speak(utterance)
        
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width - 40,
                                 height: view.frame.size.width - 40)
        label.frame = CGRect(x: 20,
                             y: view.safeAreaInsets.top + view.frame.size.width,
                             width: view.frame.size.width - 40,
                             height: 300)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
    }
    

    private func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else {
            return
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            self?.prediction = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            
            DispatchQueue.main.async {
                self?.label.numberOfLines = 0
                self?.label.lineBreakMode = NSLineBreakMode.byWordWrapping
                self?.label.text = "Predicted Text: \n\n" + self!.prediction
                self?.label.sizeToFit()
            }
        }
        
        // Process Request
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            return
        }
        imageView2.isHidden = true
        imageView.image = image
        view.addSubview(label)
        view.addSubview(imageView)
        recognizeText(image: imageView.image)
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapFunction:"))
        label.addGestureRecognizer(tap)
        tapFunction()
    }
}
