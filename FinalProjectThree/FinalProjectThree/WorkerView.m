//
//  WorkerView.m
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "WorkerView.h"
#import "WorkerCell.h"

@implementation WorkerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        UIImage *happyface = [UIImage imageNamed:@"BasicWorker"];
        /*
         * Name: name of the type of worker
         * money: the money they make per in-game hour
         * hiringcost: the money that the user must pay to hir one
         * image: the image to display in the preview section
         */
        NSDictionary *basicWorker = @{@"name" : @"Basic Worker",
                                      @"money" : @1,
                                      @"hiringCost" : @100,
                                      @"image" : happyface
                                      };
        workers = [[NSMutableArray alloc] initWithObjects: basicWorker, nil];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [workers count];
}
-(CGFloat)rowHeight{
    return 106.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // WorkerCell *cell; //WHAT TO DO HERE???
    UINib *nib = [UINib nibWithNibName:@"cell_Iphone" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"workerCell"];
    WorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workerCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:(210.0/255.0) green:(180.0/255.0) blue:(140.0/255.0) alpha:1.0]];
    
    //set the labels to the correct texta
    NSDictionary *worker = [workers objectAtIndex:[indexPath row]];
    [cell.workerNameLabel setText: [NSString stringWithFormat:@"Name: %@", [worker objectForKey:@"name"]]];
    [cell.moneyCostLabel setText: [NSString stringWithFormat:@"Makes: $%d/hr", ((NSNumber*)[worker objectForKey:@"money"]).integerValue]];
    [cell.moneyMadeLabel setText: [NSString stringWithFormat:@"Hiring Cost: $%d", ((NSNumber*)[worker objectForKey:@"hiringCost"]).integerValue]];
    //configure image to correct size
    UIImage *image = [worker objectForKey:@"image"];
    [cell.imageOfWorker setImage:image];
    
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
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
