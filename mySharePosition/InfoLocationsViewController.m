//
//  InfoLocationsViewController.m
//  mySharePosition
//
//  Created by Marco Velluto on 08/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "InfoLocationsViewController.h"
#import "SharePositionFirstViewController.h"

@interface InfoLocationsViewController ()

@end

@implementation InfoLocationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    array = [[NSMutableArray alloc] init];
        
    arrayNames = [[NSArray alloc] initWithObjects:NSLocalizedString(@"STREET_ADRESS", @"Streed Adress"),
                  NSLocalizedString(@"HOUSE_NUMBER", @"House Number"),
                  NSLocalizedString(@"CITY", @"City"),
                  NSLocalizedString(@"STATE", @"State"),
                  NSLocalizedString(@"ZIPCODE", @"zip code"),
                  NSLocalizedString(@"COUNRTY", @"Country"), nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Prende l'oggetto SharePositionFirstViewController con tutte le varibili associate.
    SharePositionFirstViewController *svc = [self.tabBarController.viewControllers objectAtIndex:0]; 
    
    array = [array init];
    [array removeAllObjects];
    
    //-- Inserisce nell'array.
    [self insertObj:(NSString *)svc.streetAdress];
    [self insertObj:svc.streetAdressSecondLine];
    [self insertObj:svc.city];
    [self insertObj:svc.state];
    [self insertObj:svc.ZIPCode];
    [self insertObj:svc.country];
    
    [self.tableView reloadData];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [arrayNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [array objectAtIndex:indexPath.row];
    
    
    /**
    cell.detailTextLabel.text = @"dettaglio";
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    cell.textLabel.text = @"valore";
    cell.textLabel.textColor = [UIColor blueColor];
    
    */
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//***********************************
#pragma mark - Metodi di Comodo
//***********************************

/**
    Inserisce nell'array @"" se l'elemento è nil.
 */
- (void)insertObj:(NSObject *)obj {
    if (obj != nil) {
        [array addObject:obj];
    }
    else
        [array addObject:@""];
}


@end
