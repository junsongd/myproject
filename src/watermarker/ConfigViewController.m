//
//  ConfigViewController.m
//  watermarker
//
//  Created by dongjunsong on 10/07/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import "ConfigViewController.h"
#import "ZYQAssetPickerController.h"
#import "CreateWaterMark.h"

@implementation ConfigViewController

UIImage *logoImage;

- (void)viewDidLoad
{
    self.OpacityController.value = 0.3;
    self.PositionXController.value = 0.3;
    self.PositionYController.value = 0.3;
    self.SizeController.value = 0.3;
    
    self.OpacityValue.text = [NSString stringWithFormat:@"%.1f",self.OpacityController.value];
    self.PositionXValue.text =[ NSString stringWithFormat:@"%1.0f%s", self.PositionXController.value * 100, "%"];
    self.PositionYValue.text =[ NSString stringWithFormat:@"%1.0f%s", self.PositionYController.value * 100, "%"];
    self.SizeValue.text = [ NSString stringWithFormat:@"%1.0f%s", self.SizeController.value * 100, "%"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.defaultImage.userInteractionEnabled = YES;
    
    [self.defaultImage addGestureRecognizer:singleTap];
    
}

- (IBAction)opacityChanged:(UISlider *)sender {
    self.OpacityValue.text = [NSString stringWithFormat:@"%.1f", [sender value]];
    [self updateImage:logoImage];
}
- (IBAction)PositionXChanged:(UISlider *)sender {
    float positionXPercentage = [sender value] * 100;
    self.PositionXValue.text = [NSString stringWithFormat:@"%1.0f%s", positionXPercentage, "%"];
    [self updateImage:logoImage];
}
- (IBAction)PositionYChanged:(UISlider *)sender {
    float positionYPercentage = [sender value] * 100;
    self.PositionYValue.text = [NSString stringWithFormat:@"%1.0f%s", positionYPercentage, "%"];
    [self updateImage:logoImage];
}
- (IBAction)SizeChanged:(UISlider *)sender {
    float sizePercentage = [sender value] * 100;
    self.SizeValue.text = [NSString stringWithFormat:@"%1.0f%s", sizePercentage, "%"];
    [self updateImage:logoImage];
}

-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
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

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    ALAsset *asset = [assets objectAtIndex:0];
    logoImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    [self updateImage:logoImage];
}

-(void)updateImage:(UIImage* )logoImage{
    
    if (logoImage !=nil) {
        UIImage* defaultBg = [UIImage imageNamed:@"default_bg.jpg"];
        CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
        UIImage* resultImage =[imageCreator imageWithTransImage:defaultBg addtransparentImage:logoImage withPositionX:self.PositionXController.value withPositionY:self.PositionYController.value withTransparentImageSize:self.SizeController.value withOpacity:self.OpacityController.value ];
        
        [self.defaultImage setImage:resultImage];
    }
}

- (void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    NSLog(@"select Photos cancel");
}

@end
