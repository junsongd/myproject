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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPhotos:(id)sender {
    
    NSLog(@"selectPhotos");
   
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
    [self.selectPhotoButton setEnabled:NO];
    
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

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    imagesaved = 0 ;
    numTotal = 1;
    self.numberTotal.text = [NSString stringWithFormat:@"%d",numTotal];
    [self.takPhotoButton setEnabled:NO];
     // add image to album
     [library saveImage:image toAlbum:@"watermarker" progressbar:(UIProgressView*)self.progressView progressNumber:self.progressNum totalNumber:(int)numTotal withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
         else
         {
             [self.takPhotoButton setEnabled:YES];

         }
    }];
     [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
 
 }

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.progressView.progress = 0.0;
    self.progressNum.text = [NSString stringWithFormat:@"%d",0];
    self.numberTotal.text = [NSString stringWithFormat:@"%d",0];
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
