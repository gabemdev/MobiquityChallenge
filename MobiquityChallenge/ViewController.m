//
//  ViewController.m
//  MobiquityChallenge
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"
#import <Dropbox/Dropbox.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/UTCoreTypes.h>


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property BOOL statusGranted;
@property (strong, nonatomic) DBAccount *account;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loingButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonButton;
@property (weak, nonatomic) IBOutlet UIButton *notesButton;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *displaySegment;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic)UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.account = [[DBAccountManager sharedManager] linkedAccount];
    if (self.account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods
- (IBAction)didPressLogin:(id)sender {
    if (![[DBAccountManager sharedManager] linkedAccount]) {
        self.loingButton.title = @"Login";
        self.statusGranted = NO;
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    else if ([[DBAccountManager sharedManager] linkedAccount]) {
        self.statusGranted = YES;
        self.loingButton.title = @"Logout";
        NSLog(@"App linked successfully!");
    }
}

- (void)uploadImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"image_%i.png", arc4random()]];
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:path error:nil];
    [file writeData:data error:nil];
    NSLog(@"Photo uploaded!");
}


#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self uploadImage:self.image];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
- (IBAction)onTakePhotoButtonTapped:(id)sender {
    if (self.image == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}




@end
