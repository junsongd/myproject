//
//  SOSPicker.m
//  SyncOnSet
//
//  Created by Christopher Sullivan on 10/25/13.
//
//

#import "SOSPicker.h"
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import "Canvas2ImagePlugin.h"
#import "CreateWaterMark.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#define CDV_PHOTO_PREFIX @"cdv_photo_"

@implementation SOSPicker

@synthesize callbackId;
@synthesize library=_library;
@synthesize imagelist=_imagelist;


- (void) getPictures:(CDVInvokedUrlCommand *)command {
	NSDictionary *options = [command.arguments objectAtIndex: 0];

	NSInteger maximumImagesCount = [[options objectForKey:@"maximumImagesCount"] integerValue];
	self.width = [[options objectForKey:@"width"] integerValue];
	self.height = [[options objectForKey:@"height"] integerValue];
	self.quality = [[options objectForKey:@"quality"] integerValue];

	// Create the an album controller and image picker
	ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] init];
	
	if (maximumImagesCount == 1) {
      albumController.immediateReturn = true;
      albumController.singleSelection = true;
   } else {
      albumController.immediateReturn = false;
      albumController.singleSelection = false;
   }
   
   ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
   imagePicker.maximumImagesCount = maximumImagesCount;
   imagePicker.returnsOriginalImage = 1;
   imagePicker.imagePickerDelegate = self;

   albumController.parent = imagePicker;
	self.callbackId = command.callbackId;
	// Present modally
	[self.viewController presentViewController:imagePicker
	                       animated:YES
	                     completion:nil];
    
    self.backgroundTask = UIBackgroundTaskInvalid;
}

- (void)doInBackgroud : (NSDictionary *)dict
{
    CGSize targetSize = CGSizeMake(self.width, self.height);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSData* data = nil;
    NSString* albumName= @"watermarker";
    //create image list
    NSMutableArray *imagelist = [[NSMutableArray alloc]   init];
    @autoreleasepool {
        
        NSArray *info = dict[@"dict"];
        int count = 0;
        
        for (NSDictionary *dict in info) {
            count++;
            
            ALAsset* asset = [dict objectForKey:@"ALAsset"];
            ELCImagePickerController *picker = dict[@"picker"];
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = NULL;
            UIImageOrientation orientation = UIImageOrientationUp;
            
            NSURL  *resourceURL = [dict objectForKey:UIImagePickerControllerReferenceURL];

            if (picker.returnsOriginalImage) {
                imgRef = [assetRep fullResolutionImage];
                orientation = [assetRep orientation];
            } else {
                imgRef = [assetRep fullScreenImage];
            }
            
            UIImage* image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:orientation];
            if (self.width == 0 && self.height == 0) {
                data = UIImageJPEGRepresentation(image, self.quality/100.0f);
            } else {
                UIImage* scaledImage = [self imageByScalingNotCroppingForSize:image toSize:targetSize];
                data = UIImageJPEGRepresentation(scaledImage, self.quality/100.0f);
            }
            //add image to list
            [imagelist addObject:image];
             self.imagelist = imagelist;
        /**
            // add image to album
            [library saveImage:image toAlbum:@"watermarker" withCount:count withCompletionBlock:^(NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    
                }

            }];**/
     /**
      for (int i = 0; i < self.imagelist.count; i++) {
             UIImage * currentimage = [self.imagelist objectAtIndex:i];
                     
      } ];**/
          
          CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
          
          UIImage* logoImage = [UIImage imageNamed:@"qr"];
          
          //  UIImage* resultImage = [imageCreator imageWithLogoImage:image logo:logoImage];
          UIImage* resultImage = [imageCreator imageWithTransImage:image addtransparentImage:logoImage withPosition:(NSString*) @"topLeft" withOpacity :(float) 1.0 ];
          
          
          
           UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
             NSLog(@"saved %d", count);
          
          
            }
        
        }
    
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self tryWriteAgain:image];
    }
}

-(void)tryWriteAgain:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}


//save image
/**
-(void) saveCurrent : (int) count{
    UIImage * currentimage = [self.imagelist objectAtIndex:0];
    // add image to album
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    [library saveImage:currentimage toAlbum:@"watermarker" withCount:count withCompletionBlock:^(NSError *error) {
        if (error) {
            //NSLog(@"%@", error.localizedDescription);
            [self saveCurrent :count];
        }
        else {
            if (self.imagelist.count > 0)
            {
                [self.imagelist removeObjectAtIndex:0];
            }
             [self saveNext: count];
        }
       
        
    }];
 
}
-(void) saveNext : (int) count{
	if (self.imagelist.count > 0) {
		UIImage *image = [self.imagelist objectAtIndex:0];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:@"watermarker" withCount:count withCompletionBlock:^(NSError *error) {
            if (error) {
                //NSLog(@"%@", error.localizedDescription);
                [self saveCurrent : count];
            }
            else {
                if (self.imagelist.count > 0)
                {
                    [self.imagelist removeObjectAtIndex:0];
                }
                  [self saveNext :count];
            }
          
            
        }];
 	 
    }
	else {
		[self allDone];
	}
}**/


-(void) saveNext{
	if (self.imagelist.count > 0) {
		UIImage *image = [self.imagelist objectAtIndex:0];
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:), nil);
	}
	else {
		[self allDone];
	}
}

-(void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error  {
	if (error) {
		//NSLog(@"%@", error.localizedDescription);
	}
	else {
		[self.imagelist removeObjectAtIndex:0];
	}
	[self saveNext];
}







-(void) allDone{
    NSLog(@"allDone" );

}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	CDVPluginResult* result = nil;
	NSMutableArray *resultStrings = [[NSMutableArray alloc] init];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    

    [NSThread detachNewThreadSelector:@selector (doInBackgroud:) // have to add colon
                toTarget:self
                withObject:@{ @"dict" : info, @"picker" : picker }];

	
	if (nil == result) {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultStrings];
	}

	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	[self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	CDVPluginResult* pluginResult = nil;
    NSArray* emptyArray = [NSArray array];
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:emptyArray];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;

    if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor == 0.0) {
            scaleFactor = heightFactor;
        } else if (heightFactor == 0.0) {
            scaleFactor = widthFactor;
        } else if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(width * scaleFactor, height * scaleFactor);
    }

    UIGraphicsBeginImageContext(scaledSize); // this will resize

    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }

    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
