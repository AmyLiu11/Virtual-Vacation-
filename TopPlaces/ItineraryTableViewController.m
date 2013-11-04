//
//  ItineraryTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-18.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "VactionHelper.h"
#import "Place+create.h"
#import "Place.h"

@interface ItineraryTableViewController ()

@end

@implementation ItineraryTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setupFetchedResultsController:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
   request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"addtime"
                                                                                    ascending:NO]];//加的早的照片时间小
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                                       initWithFetchRequest:request
                                                        managedObjectContext:context
                                                        sectionNameKeyPath:nil
                                                        cacheName:nil];
    
}

-(void)openVacation:(UIManagedDocument*)vacation
{
    [self setupFetchedResultsController:vacation.managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [VactionHelper  openVacation: @"Vacation1" usingBlock:^(UIManagedDocument*doc){
        [self openVacation:doc];// 打开了名为Vacation1的doc
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Itinerary";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //get the managed object on each row
    Place*place = [self.fetchedResultsController objectAtIndexPath:indexPath];//you use a fetched resultsController to efficiently manage the results from a Coredata fetch request to provide data for  UITableViewController(UITableViewControllerDataSourceProtocol)
    cell.textLabel.text = place.placeName;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
     // we'll segue to ANY view controller that has a place @property
    if ([segue.destinationViewController respondsToSelector:@selector(setPlace:)]  ) {
        [segue.destinationViewController performSelector:@selector(setPlace:) withObject:place];//将所选cell上的place传递
        [segue.destinationViewController setTitle:place.placeName];
    }//Sends a message to the receiver with an object as the argument. (required)place就是setPlace的参数
}

@end
