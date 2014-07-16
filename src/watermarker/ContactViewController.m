//
//  ContactViewController.m
//  watermarker
//
//  Created by dongjunsong on 07/07/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad
{
    /**
     UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/2, buttonImage.size.height/2);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    **/
    //set back button color
    
    /*
    UIColor *color_text = [UIColor colorWithRed:14.0/255.0 green:175.0/255.0 blue:82.0/255.0 alpha:1.0];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_text, UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:color_text];
     */
}


- (IBAction)email1clicked:(id)sender {
  
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:@""];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"
    [picker setToRecipients:[NSArray arrayWithObjects:@"Xuanzhaopeng@gmail.com", nil]];
    [picker setCcRecipients:[NSArray arrayWithObject:@"junsong.dong@gmail.com"]];
    
    // Fill out the email body text
    NSString *emailBody = @"Welcome to contact us";
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:NULL];

     
}

- (IBAction)email2clicked:(id)sender {
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:@""];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"`
    [picker setToRecipients:[NSArray arrayWithObjects:@"junsong.dong@gmail.com", nil]];
    [picker setCcRecipients:[NSArray arrayWithObject:@"Xuanzhaopeng@gmail.com"]];
    
    
    // Fill out the email body text
    NSString *emailBody = @"Welcome to contact us";
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
