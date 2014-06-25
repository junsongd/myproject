//
//  ViewController.m
//  waterLogo
//
//  Created by zhou mao qiao on 14-6-25.
//  Copyright (c) 2014年 zhou mao qiao. All rights reserved.
//

#import "ViewController.h"
#import "LeonAssetPickerController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize openPhotoButton;
@synthesize photoPageControl;
@synthesize photoScollerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openPhotoButtonClicked:(id)sender {
    LeonAssetPickerController *picker = [[LeonAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - LeonAssetPickerController Delegate
-(void)assetPickerController:(LeonAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [photoScollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        photoScollerView.contentSize=CGSizeMake(assets.count*photoScollerView.frame.size.width, photoScollerView.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            photoPageControl.numberOfPages=assets.count;
        });
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*photoScollerView.frame.size.width, 0, photoScollerView.frame.size.width, photoScollerView.frame.size.height)];
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [photoScollerView addSubview:imgview];
            });
        }
    });
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    photoPageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
}



@end
