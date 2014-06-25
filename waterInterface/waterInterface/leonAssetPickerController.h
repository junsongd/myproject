//
//  leonAssetPickerController.h
//  waterInterface
//
//  Created by zhou mao qiao on 14-6-25.
//  Copyright (c) 2014年 zhou mao qiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - leonAssetPickerController

@protocol leonAssetPickerControllerDelegate;

@interface leonAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, leonAssetPickerControllerDelegate> delegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;

@end

@protocol leonAssetPickerControllerDelegate <NSObject>

-(void)assetPickerController:(leonAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

-(void)assetPickerControllerDidCancel:(leonAssetPickerController *)picker;

-(void)assetPickerController:(leonAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(leonAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(leonAssetPickerController *)picker;

-(void)assetPickerControllerDidMinimum:(leonAssetPickerController *)picker;

@end

#pragma mark - leonAssetViewController

@interface leonAssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@end

#pragma mark - leonVideoTitleView

@interface leonVideoTitleView : UILabel

@end

#pragma mark - leonTapAssetView

@protocol leonTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end

@interface leonTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<leonTapAssetViewDelegate> delegate;

@end

#pragma mark - leonAssetView

@protocol leonAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface leonAssetView : UIView

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - leonAssetViewCell

@protocol leonAssetViewCellDelegate;

@interface leonAssetViewCell : UITableViewCell

@property(nonatomic,weak)id<leonAssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol leonAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - leonAssetGroupViewCell

@interface leonAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

#pragma mark - leonAssetGroupViewController

@interface leonAssetGroupViewController : UITableViewController

@end

