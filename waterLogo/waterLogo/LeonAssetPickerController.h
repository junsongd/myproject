//
//  LeonAssetPickerController.h
//  waterLogo
//
//  Created by zhou mao qiao on 14-6-25.
//  Copyright (c) 2014年 zhou mao qiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - LeonAssetPickerController

@protocol LeonAssetPickerControllerDelegate;

@interface LeonAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, LeonAssetPickerControllerDelegate> delegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;

@end

@protocol LeonAssetPickerControllerDelegate <NSObject>

-(void)assetPickerController:(LeonAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

-(void)assetPickerControllerDidCancel:(LeonAssetPickerController *)picker;

-(void)assetPickerController:(LeonAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(LeonAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(LeonAssetPickerController *)picker;

-(void)assetPickerControllerDidMinimum:(LeonAssetPickerController *)picker;

@end

#pragma mark - LeonAssetViewController

@interface LeonAssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@end

#pragma mark - LeonVideoTitleView

@interface LeonVideoTitleView : UILabel

@end

#pragma mark - LeonTapAssetView

@protocol LeonTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end

@interface LeonTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<LeonTapAssetViewDelegate> delegate;

@end

#pragma mark - LeonAssetView

@protocol LeonAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface LeonAssetView : UIView

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - LeonAssetViewCell

@protocol LeonAssetViewCellDelegate;

@interface LeonAssetViewCell : UITableViewCell

@property(nonatomic,weak)id<LeonAssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol LeonAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - LeonAssetGroupViewCell

@interface LeonAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

#pragma mark - LeonAssetGroupViewController

@interface LeonAssetGroupViewController : UITableViewController

@end

