//
//  ConfigViewController.h
//  watermarker
//
//  Created by dongjunsong on 10/07/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;

@property (weak, nonatomic) IBOutlet UISlider *OpacityController;

@property (weak, nonatomic) IBOutlet UILabel *OpacityValue;


- (IBAction)opacityChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISlider *PositionXController;

@property (weak, nonatomic) IBOutlet UILabel *PositionXValue;

- (IBAction)PositionXChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISlider *PositionYController;

@property (weak, nonatomic) IBOutlet UILabel *PositionYValue;

- (IBAction)PositionYChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISlider *SizeController;

@property (weak, nonatomic) IBOutlet UILabel *SizeValue;

- (IBAction)SizeChanged:(UISlider *)sender;

-(void)updateImage:(UIImage* )logoImage;

@end
