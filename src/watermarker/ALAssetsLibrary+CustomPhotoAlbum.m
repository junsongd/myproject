//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "CreateWaterMark.h"
  @implementation ALAssetsLibrary(CustomPhotoAlbum)


-(void)saveImageAsync:(NSMutableArray*)assets progressbar:(UIProgressView*)bar progressNumber:(UILabel*)number totalNumber:(int)total  withCompletionBlock:(SaveImageCompletion)completionBlock
{
    if(![assets count])
    {
        NSLog(@"startLocalNotification");
         UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
        notification.alertBody = @"Your photos are converted!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
         return;
    }
   
    
    ALAsset *asset = [assets objectAtIndex:0];
    
    UIImage *tempImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    // get values from NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //get value from NSUserDefaults
    float opactiy = 0;
    float positionX = 0;
    float positionY = 0;
    float size  = 0;
    if (tempImage.size.height >= tempImage.size.width) {
        opactiy = [prefs floatForKey:@"opactiy"];
        positionX = [prefs floatForKey:@"positionX"];
        positionY = [prefs floatForKey:@"positionY"];
        size  = [prefs floatForKey:@"size"];
    }else{
        opactiy = [prefs floatForKey:@"h_opactiy"];
        positionX = [prefs floatForKey:@"h_positionX"];
        positionY = [prefs floatForKey:@"h_positionY"];
        size  = [prefs floatForKey:@"h_size"];
    }
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoImage"];
    UIImage* logoImage = [UIImage imageWithData:imageData];

    CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
    UIImage* resultImage =[imageCreator imageWithTransImage:tempImage addtransparentImage:logoImage withPositionX:positionX withPositionY:positionY withTransparentImageSize:size withOpacity:opactiy ];
    
    //[assets removeObject:asset];
    NSLog(@"I shall now write image %@", resultImage);
    
   [self writeImageToSavedPhotosAlbum:resultImage.CGImage orientation:(ALAssetOrientation)resultImage.imageOrientation
                       completionBlock:^(NSURL* assetURL, NSError* error) {
                           if (error!=nil) {
                               NSLog(@"Save image error");
                           }else
                           {
                               [assets removeObject:asset];
                               [self addAssetURL: assetURL
                                         toAlbum: @"watermarker"
                                         withCompletionBlock:completionBlock];
                               
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                                       [NSThread sleepForTimeInterval:1.0];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           bar.progress = (float) (total - assets.count)/total ;
                                           [bar setNeedsDisplay];
                                           number.text = [NSString stringWithFormat:@"%d",(int)(total - assets.count)];
                                           [number setNeedsDisplay];
                                       });
                                   
                               });
                               
                               NSLog(@"left image %d", assets.count);
                           }
                           
                           [self saveImageAsync:assets progressbar:bar progressNumber:number totalNumber:total   withCompletionBlock:completionBlock];
                       }];
}

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName progressbar:(UIProgressView*)bar progressNumber:(UILabel*)number totalNumber:(int)total withCompletionBlock:(SaveImageCompletion)completionBlock

{
    // get values from NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //get value from NSUserDefaults
    float opactiy = 0;
    float positionX = 0;
    float positionY = 0;
    float size  = 0;
    if (image.size.height >= image.size.width) {
        opactiy = [prefs floatForKey:@"opactiy"];
        positionX = [prefs floatForKey:@"positionX"];
        positionY = [prefs floatForKey:@"positionY"];
        size  = [prefs floatForKey:@"size"];
    }else{
        opactiy = [prefs floatForKey:@"h_opactiy"];
        positionX = [prefs floatForKey:@"h_positionX"];
        positionY = [prefs floatForKey:@"h_positionY"];
        size  = [prefs floatForKey:@"h_size"];
    }
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoImage"];
    UIImage* logoImage = [UIImage imageWithData:imageData];
    
    CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
    UIImage* resultImage =[imageCreator imageWithTransImage:image addtransparentImage:logoImage withPositionX:positionX withPositionY:positionY withTransparentImageSize:size withOpacity:opactiy ];
         //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:resultImage.CGImage orientation:(ALAssetOrientation)resultImage.imageOrientation
                           completionBlock:^(NSURL* assetURL, NSError* error) {
                               if (error!=nil) {
                                   //NSLog(@"%@",[error localizedDescription]);
                                   NSLog(@"Save image error");
                                   
                               }else
                               {
                                   
                                    [self addAssetURL: assetURL
                                             toAlbum: @"watermarker"
                                 withCompletionBlock:completionBlock];
                                   
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                       
                                       [NSThread sleepForTimeInterval:1.0];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           bar.progress = (float) 1.0/total ;
                                           [bar setNeedsDisplay];
                                           number.text = [NSString stringWithFormat:@"%d",(int)total];
                                           [number setNeedsDisplay];
                                           
                                       });
                                       
                                   });
                                   
                                   NSLog(@"left image %d", 1);
                                   
                                   
                                   
                                }
                               
                               
                           }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum 
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

                            //compare the names of the albums
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                
                                //target album is found
                                albumWasFound = YES;
                                
                                //get a hold of the photo's asset instance
                                [self assetForURL: assetURL 
                                      resultBlock:^(ALAsset *asset) {
                                                  
                                          //add photo to the target album
                                          [group addAsset: asset];
                                          
                                          //run the completion block
                                          completionBlock(nil);
                                          
                                      } failureBlock: completionBlock];

                                //album was found, bail out of the method
                                return;
                            }
                            
                            if (group==nil && albumWasFound==NO) {
                                //photo albums are over, target album does not exist, thus create it
                                
                                __weak ALAssetsLibrary* weakSelf = self;

                                //create new assets album
                                [self addAssetsGroupAlbumWithName:albumName 
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                                  
                                                          //get the photo's instance
                                                          [weakSelf assetForURL: assetURL 
                                                                        resultBlock:^(ALAsset *asset) {

                                                                            //add photo to the newly created album
                                                                            [group addAsset: asset];
                                                                            
                                                                            //call the completion block
                                                                            completionBlock(nil);

                                                                        } failureBlock: completionBlock];
                                                          
                                                      } failureBlock: completionBlock];

                                //should be the last iteration anyway, but just in case
                                return;
                            }
                            
                        } failureBlock: completionBlock];
    
}

@end
