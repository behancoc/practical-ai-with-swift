//
//  Faces.swift
//  FaceDetector
//
//  Created by Brandon Hancock on 6/5/20.
//  Copyright © 2020 Brandon Hancock. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
    func detectImages(completion: @escaping ([VNFaceObservation]?)-> ()) {
        guard let image = self.cgImage else {return completion(nil)}
        
        let request = VNDetectFaceRectanglesRequest()
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(
                cgImage: image,
                orientation: self.cgImageOrientation
            )
            
            try? handler.perform([request])
            
            guard let observations = request.results as? [VNFaceObservation] else {
                return completion(nil)
            }
            completion(observations)
        }
    }
}
