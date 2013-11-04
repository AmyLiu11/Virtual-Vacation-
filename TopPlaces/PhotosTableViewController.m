//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-21.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "VactionHelper.h"
#import "Photo.h"
#import "Place.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController
@synthesize place = _place;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)setupFetchedResultsController:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest  fetchRequestWithEntityName:@"Photo"];
    NSLog(@"place = %@",self.place.placeName);
    fetchRequest.predicate = [NSPredicate  predicateWithFormat:@"tookPhotoAt.placeName = %@",(NSString*)self.place.placeName];//photo search,by place name
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}


-(void)openVacation:(UIManagedDocument*)vacation
{
    [self setupFetchedResultsController:vacation.managedObjectContext];
}

-(void)setPlace:(Place *)place
{
    if (_place!=place) {
        _place = place;
    }
    [VactionHelper openVacation:@"Vacation1" usingBlock:^(UIManagedDocument*doc){
        [self openVacation:doc];
    }];//每次setPlace的时候都要打开doc取photo
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"places";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *ip = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:ip];
    if ([segue.identifier isEqualToString:@"show detail"]) {
        [segue.destinationViewController setImageURL:photo.imageURL];
        [segue.destinationViewController setTitle:photo.title];
    }
}



@end
