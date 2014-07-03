//
//  Canvas2ImagePlugin.m
//  Canvas2ImagePlugin PhoneGap/Cordova plugin
//
//  Created by Tommy-Carlos Williams on 29/03/12.
//  Copyright (c) 2012 Tommy-Carlos Williams. All rights reserved.
//	MIT Licensed
//

#import "Canvas2ImagePlugin.h"
#import <Cordova/CDV.h>

@implementation Canvas2ImagePlugin
@synthesize callbackId;
@synthesize library=_library;

//-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
//{
//    self = (Canvas2ImagePlugin*)[super initWithWebView:theWebView];
//    return self;
//}

- (void)saveImageDataToLibraryFromUIImage:(NSData*)imageData
{
	UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    
    NSString *albumName=@"watermarker";
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // create album
    [library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 NSLog(@"added album:%@", albumName);
                                 
                             }
                            failureBlock:^(NSError *error) {
                                NSLog(@"error adding album");
                            }];
    // add image to album
    [library saveImage:image toAlbum:@"watermarker" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
	
}

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
	NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
	
	UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    NSString *albumName=@"watermarker";
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
   // create album
    [library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 NSLog(@"added album:%@", albumName);
                                 
                             }
                            failureBlock:^(NSError *error) {
                                NSLog(@"error adding album");
                            }];
 // add image to album
    [library saveImage:image toAlbum:@"watermarker" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
	
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"ERROR: %@",error);
		CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
		[self.webView stringByEvaluatingJavaScriptFromString:[result toErrorCallbackString: self.callbackId]];
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"IMAGE SAVED!");
		CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"Image saved"];
		[self.webView stringByEvaluatingJavaScriptFromString:[result toSuccessCallbackString: self.callbackId]];
    }
}

- (void)dealloc
{	
	[callbackId release];
    [super dealloc];
}


@end
