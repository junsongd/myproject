//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "CreateWaterMark.h"
#import "getImageConvertProgress.h"
 @implementation ALAssetsLibrary(CustomPhotoAlbum)


-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCount:(int)count withCompletionBlock:(SaveImageCompletion)completionBlock
{

    CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];

     UIImage* logoImage = [UIImage imageNamed:@"qr"];

  //  UIImage* resultImage = [imageCreator imageWithLogoImage:image logo:logoImage];
    UIImage* resultImage = [imageCreator imageWithTransImage:image addtransparentImage:logoImage withPosition:(NSString*) @"topLeft" withOpacity :(float) 1.0 ];
    
        //write the image data to the assets library (camera roll)
        [self writeImageToSavedPhotosAlbum:resultImage.CGImage orientation:(ALAssetOrientation)resultImage.imageOrientation
                           completionBlock:^(NSURL* assetURL, NSError* error) {
                               
                               //error handling
                               if (error!=nil) {
                                   //Recursively try again if we failed to save
                                   
                                   if([error code] == ALAssetsLibraryWriteBusyError)
                                       
                                   {
                                     
                                    }
                                   [self saveImage:image toAlbum:albumName withCount:count withCompletionBlock:completionBlock];
                                //   NSLog(@"%@",[error localizedDescription]);
                                //   NSLog(@"Save image error %i", count);
                                   completionBlock(error);
                                   return;
                                   

                                }else
                               {
                                   NSLog(@"Save image %i", count);

                               }
                               
                               
                               //add the asset to the custom photo album
                               [self addAssetURL: assetURL
                                         toAlbum:albumName
                             withCompletionBlock:completionBlock];
                               
                           }];
        
      /**
    
    //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:resultImage.CGImage orientation:(ALAssetOrientation)resultImage.imageOrientation
                        completionBlock:^(NSURL* assetURL, NSError* error) {
                              
                          //error handling
                          if (error!=nil) {
                              //Recursively try again if we failed to save
                              
                              if([error code] == ALAssetsLibraryWriteBusyError)
                                  
                              {
                                  [self saveImage:image toAlbum:albumName withCount:count withCompletionBlock:completionBlock];
                              }
                              
                              NSLog(@"%@",[error localizedDescription]);
 
                              
                              //completionBlock(error);
                              return;
                          }
                            
                            NSLog(@"Save image %i", count);
                         
                          //add the asset to the custom photo album
                          [self addAssetURL: assetURL 
                                    toAlbum:albumName 
                        withCompletionBlock:completionBlock];
                          
                      }];**/
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
