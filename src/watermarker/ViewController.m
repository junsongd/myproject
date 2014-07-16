//
//  ViewController.m
//  watermarker
//
//  Created by dongjunsong on 28/06/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import "ViewController.h"
#import "ZYQAssetPickerController.h"
#import "CreateWaterMark.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    
    UIScrollView *src;
    
    UIPageControl *pageControl;
    int imagesaved  ;
    int numTotal  ;
}

- (IBAction)selectPhotos:(id)sender;
 @property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation ViewController
@synthesize progressView;
@synthesize progressNum;
@synthesize numberTotal;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   // UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg3.jpg"]];
   // self.view.backgroundColor = background;
    self.progressView.progress = 0.0;
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.numberTotal.text = [NSString stringWithFormat:@"%d",0];
    imagesaved = 0;
     // self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    //self.configButton.hidden = TRUE;
    self.selectPhotoButton.layer.borderWidth = 1;
    self.takPhotoButton.layer.borderWidth = 1;
    self.contactButton.layer.borderWidth = 1;

    UIColor *color_border = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];

    self.takPhotoButton.layer.borderColor = color_border.CGColor;
    self.selectPhotoButton.layer.borderColor = color_border.CGColor;
    self.contactButton.layer.borderColor = color_border.CGColor;
    
    [self setTitle:@"Water Marker"];
    
    UIColor *color_text = [UIColor colorWithRed:14.0/255.0 green:175.0/255.0 blue:82.0/255.0 alpha:1.0];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_text, UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    //self.navigationController.navigationBar.tintColor = color_text;
   

 }
- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
       // titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
     }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPhotos:(id)sender {
    
    BOOL result = [self checkButtonAvailable];
    if (!result) {
        return;
     }
    
    NSLog(@"selectPhotos");
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.progressView.progress = 0.0;

    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 50;
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
- (void)updateUI:(NSTimer *)timer
{
    static int count =0;
    count++;
    
    if (count <=10) {
        self.progressLabel.text = [NSString stringWithFormat:@"%d %%",count*10];
        self.progressView.progress = (float)count/10.0f;
    }
    else {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}



#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    //self.LoadingMask.hidden =  NO;
   // self.loadingView.hidden = NO;

    self.numberTotal.text = [NSString stringWithFormat:@"%lu",assets.count];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            pageControl.numberOfPages=assets.count;
        });
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        imagesaved = 0 ;
        numTotal = assets.count;
        
        [library saveImageAsync:[NSMutableArray arrayWithArray:assets] progressbar:self.progressView progressNumber:self.progressNum totalNumber:(int)assets.count withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Big error: %@", [error description]);
            }
            else
            {
                //imagesaved ++;
                //self.progressView.progress = (float) imagesaved/assets.count ;
                //self.progressNum.text = [NSString stringWithFormat:@"%d",imagesaved];
                if(assets.count == 1)
                {
                    [self.selectPhotoButton setEnabled:YES];

                }
               
            }
        }];
           
    });
}
- (void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    NSLog(@"select Photos cancel");

    self.progressView.progress = 0.0;
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.numberTotal.text = [NSString stringWithFormat:@"%d",0];
    imagesaved = 0 ;
}



- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self tryWriteAgain:image];
    }else
    {
        imagesaved ++;
        //  self.progressView.progress +=  imagesaved/assets.count;
        self.progressView.progress = (float) imagesaved/numTotal ;
        self.progressNum.text = [NSString stringWithFormat:@"%d",imagesaved];
        self.numberTotal.text = [NSString stringWithFormat:@"%d",numTotal];
        

    }
}

-(void)tryWriteAgain:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

- (IBAction)takePhotoButton:(id)sender {
    BOOL result = [self checkButtonAvailable];
    if (!result) {
        return;
    }
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.progressView.progress = 0.0;
    //checks if device has a camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You don't have a camera for this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        //shows above alert if there's no camera
        [noCameraAlert show];
    }
    
    //otherwise, show a modal for taking a photo
    else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id)self;

        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
}
#pragma -
#pragma mark Image picker delegate methdos
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // self.LoadingMask.hidden =  NO;
    // self.loadingView.hidden = NO;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    imagesaved = 0 ;
    numTotal = 1;
    self.numberTotal.text = [NSString stringWithFormat:@"%d",numTotal];
     // add image to album
     [library saveImage:image toAlbum:@"watermarker" progressbar:(UIProgressView*)self.progressView progressNumber:self.progressNum totalNumber:(int)numTotal withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
     [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
 
 }

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.progressView.progress = 0.0;
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.numberTotal.text = [NSString stringWithFormat:@"%d",0];
   // self.LoadingMask.hidden =  YES;

    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (UIActivityIndicatorView *)showSimpleActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}
- (BOOL) checkButtonAvailable
{
    NSString *totalString = self.numberTotal.text ;
    NSString *currentNumber = self.progressNum.text;
    if ( totalString.intValue >  0 && currentNumber.intValue < totalString.intValue){
        NSLog(@"test");
        NSString *title = @"Alert";
        NSString *message = @"Task is not finished yet, please wait...";
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        return false;
    }
    return TRUE;
}

@end
