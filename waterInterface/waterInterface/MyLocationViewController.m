//
//  MyLocationViewController.m
//  waterInterface
//
//  Created by zhou mao qiao on 14-6-24.
//  Copyright (c) 2014年 zhou mao qiao. All rights reserved.
//

#import "MyLocationViewController.h"

#import "LeonAssetPickerController.h"


@interface MyLocationViewController ()

@end

@implementation MyLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self performSegueWithIdentifier:@"openPhoto" sender:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
- (IBAction)openPhotoClick:(id)sender {
    leonAssetPickerController *picker = [[leonAssetPickerController alloc] init];
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

@end
