//**
/**
 * © TODO1 SERVICES, INC. (‘TODO1’) All rights reserved, 2000, 2018.
 *
 *  This work is protected by the United States of America copyright laws.
 *
 *  All information contained herein is and remains the property of
 *  TODO1 [and its suppliers, if any] .
 *  Dissemination of this information or reproduction of this material
 *  is not permitted unless prior written consent is obtained
 *  from TODO1 SERVICES, INC.
 *
 *  This work is protected by the United States of America copyright laws.
 *
 *  All information contained herein is and remains the property of
 *  TODO1 [and its suppliers, if any] .
 *  Dissemination of this information or reproduction of this material
 *  is not permitted unless prior written consent is obtained
 *  from TODO1 SERVICES, INC.
 */

import Foundation
import UIKit

@objc(QrCodePlugin) class QrCodePlugin : CDVPlugin {
  @objc(shareqr:)
  func shareqr(command: CDVInvokedUrlCommand) {
    let dictionary :NSDictionary = command.argument(at: 0) as! NSDictionary
    let message : String = dictionary.object(forKey: "message") as! String
    let subject : String = dictionary.object(forKey: "subject") as! String
    let qr : String = dictionary.object(forKey: "qr") as! String
    var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin QR Failed");
    if(generateQRCode(messageInfo: message , subjectInfo: subject, qrInfo: qr)){
       pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin QR succeeded");
    }
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
    
    func generateQRCode(messageInfo message: String, subjectInfo subject: String, qrInfo qr: String )-> Bool{
       let topImage = getQRCodeImage(from: qr)
       let bottomImage = UIImage(named: "ic_bancolombia")
       let size = CGSize(width: 500, height: 500)
       UIGraphicsBeginImageContext(size)
       let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
       let centerX  = (areaSize.size.height - 80)/2
       let centerY  = (areaSize.size.width - 80)/2
       let areaSize2 = CGRect(x: centerX, y: centerY, width: 80, height: 80)
       bottomImage!.draw(in: areaSize2)
       topImage!.draw(in: areaSize, blendMode: .overlay, alpha: 1)
       if let image = UIGraphicsGetImageFromCurrentImageContext() {
           UIGraphicsEndImageContext()
           let activityViewController = UIActivityViewController(activityItems: [message, image], applicationActivities: [])
           activityViewController.setValue(subject, forKey: "Subject")
        self.viewController.present(activityViewController, animated: true,completion:nil)
            return true
       }else{
            return false
        }
    }

    func getQRCodeImage(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
