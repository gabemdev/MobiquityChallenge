//
//  DetailImagesViewController.m
//  MobiquityChallenge
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "DetailImagesViewController.h"
#import <Dropbox/Dropbox.h>
#import "DetailTableViewCell.h"
#import "ImageDetailViewController.h"

@interface DetailImagesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DBAccount *account;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *imagesArray;

@end

@implementation DetailImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:self.account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[DBFilesystem sharedFilesystem] listFolder:[DBPath root] error:nil] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.imagesArray = [[DBFilesystem sharedFilesystem] listFolder:[DBPath root] error:nil];
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    DBFileInfo *fileInfo= self.imagesArray[indexPath.row];
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:[fileInfo path] error:nil];
    DBFileStatus *fileStatus = file.status;
    if (fileStatus.cached) {
        cell.DBImage.image = [UIImage imageWithData:[file readData:nil]];
        cell.imageInfo.text = [[fileInfo path] name];
    }

    if (!file){
        cell.backgroundColor = [UIColor colorWithRed:71.0/255.0 green:158.0/255.0 blue:233.0/255.0 alpha:1];
        cell.imageInfo.text = @"";
    }
    return cell;
}


#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageDetailViewController *vc = segue.destinationViewController;
    NSArray *items = [[DBFilesystem sharedFilesystem] listFolder:[DBPath root] error:nil];
    DBFileInfo *fileInfo= items[[self.tableView indexPathForSelectedRow].row];
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:[fileInfo path] error:nil];
    DBFileStatus *fileStatus = file.status;
    if (fileStatus.cached) {
        vc.detailimage = [UIImage imageWithData:[file readData:nil]];
    }
}

@end
