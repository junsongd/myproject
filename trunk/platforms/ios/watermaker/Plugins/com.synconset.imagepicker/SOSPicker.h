//
//  SOSPicker.h
//  SyncOnSet
//
//  Created by Christopher Sullivan on 10/25/13.
//
//

#import <Cordova/CDVPlugin.h>
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface SOSPicker : CDVPlugin <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, atomic) ALAssetsLibrary* library;
@property (strong, atomic) NSMutableArray* imagelist;

@property (copy)   NSString* callbackId;

- (void) getPictures:(CDVInvokedUrlCommand *)command;
- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize;
-(void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo ;
 -(void) saveNext;
-(void)tryWriteAgain:(UIImage *)image withUrl : (NSURL *)assetURL toAlbum :(NSString *) albumName;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) NSMutableArray  *_imagelist;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end
