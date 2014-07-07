//
//  ViewController.h
//  watermarker
//
//  Created by dongjunsong on 28/06/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressNum;
@property (weak, nonatomic) IBOutlet UILabel *numberTotal;
@property (weak, nonatomic) IBOutlet UIButton *takPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
- (BOOL) checkButtonAvailable;
- (IBAction)takePhotoButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@end
