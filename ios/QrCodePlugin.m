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

#import "QrCodePlugin.h"

@implementation QrCodePlugin

- (void)shareqr: (CDVInvokedUrlCommand*)command;
{
    NSDictionary *params = (NSDictionary*) [command argumentAtIndex:0];
    CDVPluginResult* pluginResult = nil;
    if (params != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    NSString *message = [params objectForKey:@"message"];
    NSString *subject = [params objectForKey:@"subject"];
    NSString *qr = [params objectForKey:@"qr"];
    [self generateQrCode:message subject:subject qr:qr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)generateQrCode:(NSString *)messageString subject:(NSString *)subject qr:(NSString *)qrString{
    CIImage *qrImage = [self createQRForString:qrString];
    UIImage *topImage  = [[UIImage alloc] initWithCIImage:qrImage];
    UIImage *bottomImage  = [UIImage imageNamed:@"ic_bancolombia"];

    CGSize size = CGSizeMake(500, 500);
    UIGraphicsBeginImageContext( size );
    CGRect areaSize = CGRectMake(0,0,size.width,size.height);
    CGFloat centerX = (areaSize.size.height - 80)/2;
    CGFloat centerY = (areaSize.size.width - 80)/2;
    CGRect areaSize2 =CGRectMake(centerX,centerY,80,80);
    [bottomImage drawInRect:areaSize2];
    [topImage drawInRect:areaSize blendMode:kCGBlendModeOverlay alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[messageString, newImage] applicationActivities:nil];
    [activityVC setValue:subject forKey:@"Subject"];
    [self.viewController presentViewController:activityVC animated:YES completion:nil];
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    return qrFilter.outputImage;
}

@end
