//
//  CreateWaterMark.h
//  watermaker
//
//  Created by dongjunsong on 28/06/2014.
//
//

#import <Foundation/Foundation.h>

@interface CreateWaterMark : NSObject
-(UIImage *)imageWithLogoImage:(UIImage *)img logo:(UIImage *)logo;
//-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg ;
-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg withPosition:(NSString *) position withOpacity :(float)opacity;
-(UIImage *)resizedImage:(UIImage *)image convertToSize:(CGSize)size;
@end
