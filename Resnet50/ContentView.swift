//
//  ContentView.swift
//  Resnet50
//
//  Created by Zhixian Piao on 2022/02/21.
//

import SwiftUI
import CoreML
import Vision


struct ContentView: View {
    
    @State var classificationLabel = ""
    
    func createClassificationRequest() -> VNCoreMLRequest {
        do {
            let configuration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: Resnet50(configuration: configuration).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                performClassification(request: request)
            })
            
            return request
        } catch {
            fatalError("Can't read model")
        }
    }
    
    func classifyImage(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Can't convert")
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        let classificationRequest = createClassificationRequest()
        
        do {
            try handler.perform([classificationRequest])
        } catch {
            fatalError("Can't recognize")
        }
    }
    
    //　画像分類
    func performClassification(request: VNRequest) {
        guard let results = request.results else {
            return
        }
        
        let classification = results as! [VNClassificationObservation]
    
        classificationLabel = classification[0].identifier + " " + classification[1].identifier + " " + classification[2].identifier
    }
    
    var body: some View {
        VStack {
            Text(classificationLabel)
                .padding()
                .font(.title)
            Image("Dogs_05")
                .resizable()
                .frame(width: 300, height: 200)
            Button(action: {
                classifyImage(image: UIImage(named: "Dogs_05")!)
            }, label: {
                Text("What's this?")

            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
