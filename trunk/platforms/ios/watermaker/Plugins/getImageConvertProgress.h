//
//  getImageConvertProgress.h
//  watermaker
//
//  Created by dongjunsong on 28/06/2014.
//
//

#import <Cordova/CDVPlugin.h>

#import <Foundation/Foundation.h>

@interface getImageConvertProgress : CDVPlugin
{
    NSString *_callbackId;
    NSString *_count;
}

@property (nonatomic, retain) NSString *callbackId;
@property (nonatomic, retain) NSString *count;

- (void)getInfo:(CDVInvokedUrlCommand*)command;
- (int)getInfoPara : (int) count;

@end