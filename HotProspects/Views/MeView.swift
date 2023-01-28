//
//  MeView.swift
//  WeSplit
//
//  Created by Muhammad Farid Ullah on 21/01/2023.
//

import SwiftUI
//Core Image lets us generate a QR code from any input string.
import CoreImage.CIFilterBuiltins // Core Image filters
import CoreImage

//ask the user to enter their name and email address in a form, use those two pieces of information to generate a QR code identifying them

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "Farid@icloud.com"
    
    let context = CIContext()//to store an active Core Image context.
    let filter = CIFilter.qrCodeGenerator()//instance of Core Image’s QR code generator filter.
    
    @State private var qrCode = UIImage()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter name", text: $name)
                    .textContentType(.name)
                    .font(.title2)
                
                TextField("Ente email", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title2)
                
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let image = generateQRCode(text: "\(name)\n\(emailAddress)")
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: image)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                
            }
            .navigationTitle("Scan QR")
            .onAppear(perform: updateCode) //when view shows, make the qrCode.
            .onChange(of: name) {_ in updateCode() } //when name or email changes, update the qrCode and do not update when the view body updates.
            .onChange(of: emailAddress) { _ in updateCode() }
        }
    }
    
    //Core Image filters requires us to provide some input data, then convert the output CIImage into a CGImage, then that CGImage into a UIImage.
    
    func generateQRCode(text: String) -> UIImage {
        filter.message = Data(text.utf8)  //Our input for the filter will be a string, but the input for the filter is Data, so we need to convert that.
        
        if let outPutimage = filter.outputImage { //read the image from our filter.
            if let cgImage = context.createCGImage(outPutimage, from: outPutimage.extent) {
                return UIImage(cgImage: cgImage) //return UIimage
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(text: "\(name)\n\(emailAddress)")
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
