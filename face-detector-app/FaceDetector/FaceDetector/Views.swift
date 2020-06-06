//
//  Views.swift
//  FaceDetector
//
//  Created by Brandon Hancock on 6/5/20.
//  Copyright © 2020 Brandon Hancock. All rights reserved.
//

import SwiftUI

struct TwoStateButton: View {
    private let text: String
    private let disabled: Bool
    private let background: Color
    private let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).font(.title).bold().foregroundColor(.white)
                Spacer()
                }.padding().background(background).cornerRadius(10)
        }.disabled(disabled)
    }
    
    init(text: String,
         disabled: Bool,
         background: Color = .blue,
         action: @escaping() -> Void) {
        self.text = text
        self.disabled = disabled
        self.background = disabled ? .gray : background
        self.action = action
    }
}

struct Main View: View {
    private let image : UIImage
    private let text: String
    private let button : TwoStateButton
    
    var body: some View {
        VStack {
            Image(uiImage: image).resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text(text).font(.title).bold()
            Spacer()
            self.button
        }
    }
    
    init(image: UIImage, text: String, button: ()-> TwoStateButton) {
        self.image = image
        self.text = text
        self.button = button()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    private(set) var selectedImage: UIImage?
    private(set) var camerasSource: Bool
    private let completion: (UIImage?) ->()
    
    init(camera: Bool = false, completion: @escaping(UIImage?) ->()) {
        self.camerasSource = camera
        self.completion = completion
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
            let coordinator  = Coordinator(self)
            coordinator.completion = self.completion
            
            return coordinator
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = context.coordinator
            
            imagePickerController.sourceType = camerasSource ? .camera: .photoLibrary
            
            return imagePickerController
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var patent: ImagePicker
        var completion: ((UIImage?) -> ()?)
        
        init(_ imagePickerControllerWrapper: ImagePicker) {
            self.parent = imagePickerControllerWrapper
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
            print("Image picker complete...")
            
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            picker.dismiss(animated: true)
            completion(selectedImage)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Image picker cancelled... ")
            
            picker.dismiss(animated: true)
            completion? (nil))
        }
    }
}
