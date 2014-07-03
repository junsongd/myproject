//
//  getImageConvertProgress.m
//  watermaker
//
//  Created by dongjunsong on 28/06/2014.
//
//

#import "getImageConvertProgress.h"

@implementation getImageConvertProgress

@synthesize callbackId=_callbackId;
@synthesize count=_count;


- (void)getInfo:(CDVInvokedUrlCommand*)command
{
     self.callbackId = command.callbackId;
 
     //get the callback id
    
    NSArray *localizations = [[NSBundle mainBundle]preferredLocalizations];
    //NSLog(@"%@", [localizations objectAtIndex:0]);
    
    NSString* myNewString = [NSString stringWithFormat:@"%@", self.count ];

    NSString *jsResponse = [[CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                              messageAsString:myNewString]
                            toSuccessCallbackString:self.callbackId];
    [self writeJavascript:jsResponse];
}
- (int)getInfoPara : (int) count
{
    NSString* myNewString = [NSString stringWithFormat:@"%d", count];
    self.count  = myNewString;

    //get the callback id
     NSLog(@"getInfoPara %@",myNewString);
    return count;
}
@end
