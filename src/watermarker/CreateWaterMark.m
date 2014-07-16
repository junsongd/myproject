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

//图片缩放
-(UIImage *)resizedImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg withPositionX:(float) positionX withPositionY:(float) positionY withTransparentImageSize:(float) resize withOpacity :(float)opacity
{
    CGFloat original_height = useImage.size.height;
    CGFloat original_width = useImage.size.width;
    
    CGFloat logo_height = transparentimg.size.height;
    CGFloat logo_width = transparentimg.size.width;
    
    CGFloat logo_resized_height = 0;
    CGFloat logo_resized_wight = 0;
    
    Float32 resize_percentage = resize;
    
    if (original_height >= original_width) {
        logo_resized_wight = original_width * resize_percentage;
        logo_resized_height = logo_resized_wight * logo_height / logo_width;
    }else{
        logo_resized_height = original_height * resize_percentage;
        logo_resized_wight = logo_resized_height * logo_width / logo_height;
    }
    
    Float32 padding_percentage_X = positionX;
    Float32 padding_percentage_Y = positionY;
    
    CGFloat logo_padding_X = original_width * padding_percentage_X;
    CGFloat logo_padding_Y = original_height * padding_percentage_Y;
    
    CGSize logo_resize = CGSizeMake(logo_resized_wight, logo_resized_height);
    
    transparentimg = [self resizedImage:transparentimg convertToSize:logo_resize];
    
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    if (original_height >= original_width) {
        [transparentimg drawInRect:CGRectMake(logo_padding_X, logo_padding_Y, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    }else{
        [transparentimg drawInRect:CGRectMake(logo_padding_Y, logo_padding_X, transparentimg.size.height ,transparentimg.size.width ) blendMode:kCGBlendModeNormal alpha:opacity];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


//加半透明的水印
-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg withPosition:(NSString *) position withOpacity :(float)opacity
{
    CGFloat original_height = useImage.size.height;
    CGFloat original_width = useImage.size.width;
    
    CGFloat logo_height = transparentimg.size.height;
    CGFloat logo_width = transparentimg.size.width;
    
    CGFloat logo_resized_height = 0;
    CGFloat logo_resized_wight = 0;
    
    Float32 resize_percentage = 0.30;
    
    if (original_height >= original_width) {
        logo_resized_wight = original_width * resize_percentage;
        logo_resized_height = logo_resized_wight * logo_height / logo_width;
    }else{
        logo_resized_height = original_height * resize_percentage;
        logo_resized_wight = logo_resized_height * logo_width / logo_height;
    }
    
    Float32 padding_percentage = 0.05;

    CGFloat logo_padding = original_height*padding_percentage;
    
    CGSize logo_resize = CGSizeMake(logo_resized_wight, logo_resized_height);
    
    transparentimg = [self resizedImage:transparentimg convertToSize:logo_resize];
    
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    NSString * centre = @"centre";
    NSString * topLeft = @"topLeft";
    NSString * topRight = @"topRight";
    NSString * bottomLeft = @"bottomLeft";
    NSString * bottomRight = @"bottomRight";

     if(position == centre)
     {
       // [transparentimg drawInRect:CGRectMake((useImage.size.width-transparentimg.size.width)/2, (useImage.size.height-transparentimg.size.height)/2, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
         [transparentimg drawInRect:CGRectMake((useImage.size.width-transparentimg.size.width)/2, (useImage.size.height-transparentimg.size.height)/2, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
     
     }
    if(position == topLeft)
    {
       [transparentimg drawInRect:CGRectMake(logo_padding, logo_padding, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];    }
    if(position == topRight)
    {
        [transparentimg drawInRect:CGRectMake(useImage.size.width-transparentimg.size.width-logo_padding, logo_padding, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];
        
    }
    if(position == bottomLeft)
    {
        [transparentimg drawInRect:CGRectMake(logo_padding, useImage.size.height-transparentimg.size.height-logo_padding, transparentimg.size.width, transparentimg.size.height) blendMode:kCGBlendModeOverlay alpha:opacity];    }
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
