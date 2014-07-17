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
    /**
    self.OpacityController.value = 0.3;
    self.PositionXController.value = 0.3;
    self.PositionYController.value = 0.3;
    self.SizeController.value = 0.3;
    
    self.OpacityValue.text = [NSString stringWithFormat:@"%.1f",self.OpacityController.value];
    self.PositionXValue.text =[ NSString stringWithFormat:@"%1.0f%s", self.PositionXController.value * 100, "%"];
    self.PositionYValue.text =[ NSString stringWithFormat:@"%1.0f%s", self.PositionYController.value * 100, "%"];
    self.SizeValue.text = [ NSString stringWithFormat:@"%1.0f%s", self.SizeController.value * 100, "%"];
    **/
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap2.numberOfTapsRequired = 1;
    
    
    self.HorizontalDefaultImage.userInteractionEnabled = YES;
    [self.HorizontalDefaultImage addGestureRecognizer:singleTap];
    
    self.defaultImage.userInteractionEnabled = YES;
    [self.defaultImage addGestureRecognizer:singleTap2];
    
    self.VersionSegmentControl.selectedSegmentIndex = 0;
    
    self.defaultImage.hidden = false;
    self.HorizontalDefaultImage.hidden = true;
    
    [self initController];
    
    }

- (void)initController {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //get value from NSUserDefaults
    
    float opactiy = 0;
    float positionX = 0;
    float positionY = 0;
    float size  = 0;
    
    if(self.VersionSegmentControl.selectedSegmentIndex == 0){
        //Vertical
        self.defaultImage.hidden = false;
        self.HorizontalDefaultImage.hidden = true;
        
        
        opactiy = [prefs floatForKey:@"opactiy"];
        positionX = [self roundValue:[prefs floatForKey:@"positionX"]];
        positionY = [prefs floatForKey:@"positionY"];
        size  = [prefs floatForKey:@"size"];
    }else{
        //Horizontal
        self.defaultImage.hidden = true;
        self.HorizontalDefaultImage.hidden = false;
        
        
        opactiy = [prefs floatForKey:@"h_opactiy"];
        positionX = [self roundValue:[prefs floatForKey:@"h_positionX"]];
        positionY = [prefs floatForKey:@"h_positionY"];
        size  = [prefs floatForKey:@"h_size"];
    }
    
    NSData* imageData = [prefs objectForKey:@"logoImage"];
    logoImage = [UIImage imageWithData:imageData];
    
    // init value
    self.OpacityController.value = opactiy;
    self.PositionXController.value = positionX;
    self.PositionYController.value = positionY;
    self.SizeController.value = size;
    // init controller
    
    self.OpacityValue.text = [NSString stringWithFormat:@"%.1f",opactiy];
    self.PositionXValue.text =[ NSString stringWithFormat:@"%1.0f%s", positionX* 100, "%"];
    self.PositionYValue.text =[ NSString stringWithFormat:@"%1.0f%s", positionY* 100, "%"];
    self.SizeValue.text = [ NSString stringWithFormat:@"%1.0f%s", size * 100, "%"];
    // update image
    [self updateImage:logoImage];


}

- (float)roundValue:(float)floatValue{
    float sb = round(floatValue * 100) /100;
    return sb;
}

- (IBAction)opacityChanged:(UISlider *)sender {
    self.OpacityValue.text = [NSString stringWithFormat:@"%.1f", [sender value]];
    
    //[self updateImage:logoImage];
   
}

- (IBAction)opacityTouchUpInside:(UISlider *)sender {
    [self updateImage:logoImage];
}

- (IBAction)PositionXChanged:(UISlider *)sender {
    float positionXPercentage = [sender value] * 100;
    self.PositionXValue.text = [NSString stringWithFormat:@"%1.0f%s", positionXPercentage, "%"];
    //[self updateImage:logoImage];
}

- (IBAction)PositionXTouchUpInside:(UISlider *)sender {
    //float positionXPercentage = [sender value] * 100;
    //self.PositionXValue.text = [NSString stringWithFormat:@"%1.0f%s", positionXPercentage, "%"];
    [self updateImage:logoImage];
}

- (IBAction)PositionYChanged:(UISlider *)sender {
    float positionYPercentage = [sender value] * 100;
    self.PositionYValue.text = [NSString stringWithFormat:@"%1.0f%s", positionYPercentage, "%"];
    //[self updateImage:logoImage];
}

- (IBAction)PositionYTouchUpInside:(UISlider *)sender {
    [self updateImage:logoImage];
}

- (IBAction)SizeChanged:(UISlider *)sender {
    float sizePercentage = [sender value] * 100;
    self.SizeValue.text = [NSString stringWithFormat:@"%1.0f%s", sizePercentage, "%"];
    //[self updateImage:logoImage];
}

- (IBAction)SizeTouchUpInside:(UISlider *)sender {
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
        
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        //opacity
        float opacity_save = self.OpacityController.value;
        //posistionX
        float posistionX_save = self.PositionXController.value;
        //posistionY
        float posistionY_save = self.PositionYController.value;
        //size
        float size_save = self.SizeController.value;
        
        if(self.VersionSegmentControl.selectedSegmentIndex == 0){
            //Vertical
            [self.defaultImage setImage:nil];
            
            UIImage* defaultBg = [UIImage imageNamed:@"default_bg.jpg"];
            CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
            UIImage* resultImage =[imageCreator imageWithTransImage:defaultBg addtransparentImage:logoImage withPositionX:self.PositionXController.value withPositionY:self.PositionYController.value withTransparentImageSize:self.SizeController.value withOpacity:self.OpacityController.value ];
            
            [self.defaultImage setImage:resultImage];
            
            [prefs setFloat:opacity_save forKey:@"opactiy"];
            [prefs setFloat:posistionX_save forKey:@"positionX"];
            [prefs setFloat:posistionY_save forKey:@"positionY"];
            [prefs setFloat:size_save forKey:@"size"];
        }else{
            //Horizontal
            [self.HorizontalDefaultImage setImage:nil];
            
            UIImage* defaultBg = [UIImage imageNamed:@"default_bg_h.jpg"];
            CreateWaterMark  *imageCreator = [[CreateWaterMark alloc] init];
            UIImage* resultImage =[imageCreator imageWithTransImage:defaultBg addtransparentImage:logoImage withPositionX:self.PositionXController.value withPositionY:self.PositionYController.value withTransparentImageSize:self.SizeController.value withOpacity:self.OpacityController.value ];
            
            [self.HorizontalDefaultImage setImage:resultImage];
            
            [prefs setFloat:opacity_save forKey:@"h_opactiy"];
            [prefs setFloat:posistionX_save forKey:@"h_positionX"];
            [prefs setFloat:posistionY_save forKey:@"h_positionY"];
            [prefs setFloat:size_save forKey:@"h_size"];
        }
        //logo image
        
        [prefs setObject:UIImagePNGRepresentation(logoImage)  forKey:@"logoImage"];
    }
    
}

- (void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    NSLog(@"select Photos cancel");
}

- (IBAction)VersionChanged:(UISegmentedControl *)sender {
    [self initController];
}
@end
