//
//  ImageDetailViewController.m
//  MobiquityChallenge
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ImageDetailViewController.h"

@interface ImageDetailViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = self.detailimage;
}


#pragma mark - Actions

- (IBAction)onShareButtonTapped:(id)sender {

    NSString *title = @"Check this image out!";
    UIImage *shareImage = self.detailimage;
    NSArray *activityItems;

    if (self.imageView.image != nil) {
        activityItems = @[title, shareImage];
    } else {
        activityItems = @[title];
    }

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                     applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
