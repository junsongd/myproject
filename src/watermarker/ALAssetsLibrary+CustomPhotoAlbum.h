//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
 typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCount:(int)count withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)saveImageAsync:(NSMutableArray*)assets progressbar:(UIProgressView*)bar progressNumber:(UILabel*)number totalNumber:(int)total withMask:(UIView*) loadingMask withIndicator: (UIActivityIndicatorView *) loadingview  withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName progressbar:(UIProgressView*)bar progressNumber:(UILabel*)number totalNumber:(int)total withCompletionBlock:(SaveImageCompletion)completionBlock;

@end