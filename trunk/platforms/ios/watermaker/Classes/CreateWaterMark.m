//
//  CreateWaterMark.m
//  watermaker
//
//  Created by dongjunsong on 28/06/2014.
//
//

#import "CreateWaterMark.h"

@implementation CreateWaterMark
#pragma mark - 加图片水印
-(UIImage *)imageWithLogoImage:(UIImage *)img logo:(UIImage *)logo
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake(w-logoWidth, 0, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}
//加半透明的水印
-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg withPosition:(NSString *) position withOpacity :(float)opacity
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    //bottom left
   // [transparentimg drawInRect:CGRectMake(20, useImage.size.height-transparentimg.size.height-20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:0.6f];
    // centre
   // [transparentimg drawInRect:CGRectMake((useImage.size.width-transparentimg.size.width)/2, (useImage.size.height-transparentimg.size.height)/2, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:0.6f];
    // bottom right
   // [transparentimg drawInRect:CGRectMake(useImage.size.width-transparentimg.size.width-20, useImage.size.height-transparentimg.size.height-20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:0.6f];
    // top left
  //   [transparentimg drawInRect:CGRectMake(20, 20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:0.6f];
    // top right
   // [transparentimg drawInRect:CGRectMake(useImage.size.width-transparentimg.size.width-20, 20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:0.6f];
    NSString * centre = @"centre";
    NSString * topLeft = @"topLeft";
    NSString * topRight = @"topRight";
    NSString * bottomLeft = @"bottomLeft";
    NSString * bottomRight = @"bottomRight";

     if(position == centre)
     {
        [transparentimg drawInRect:CGRectMake((useImage.size.width-transparentimg.size.width)/2, (useImage.size.height-transparentimg.size.height)/2, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
     
     }
    if(position == topLeft)
    {
       [transparentimg drawInRect:CGRectMake(20, 20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];    }
    if(position == topRight)
    {
        [transparentimg drawInRect:CGRectMake(useImage.size.width-transparentimg.size.width-20, 20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
        
    }
    if(position == bottomLeft)
    {
        [transparentimg drawInRect:CGRectMake(20, useImage.size.height-transparentimg.size.height-20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];    }
    if(position == bottomRight)
    {
        [transparentimg drawInRect:CGRectMake((useImage.size.width-transparentimg.size.width)/2, (useImage.size.height-transparentimg.size.height)/2, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
        
    }
    
  //  [transparentimg drawInRect:CGRectMake(useImage.size.width-transparentimg.size.width-20, 20, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
    

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
@end
