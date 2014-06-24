//
//  BuildView.m
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "BuildView.h"

@implementation BuildView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        UIImage *happyface = [UIImage imageNamed:@"BasicUp"];
        NSDictionary *basicOffice = @{@"name" : @"Basic Office",
                                      @"cost" : @500,
                                      @"image" : happyface,
                                      @"bonuses" : @"None"
                                      };
        buildings = [[NSMutableArray alloc] initWithObjects: basicOffice, nil];
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
    return [buildings count];
}
-(CGFloat)rowHeight{
    return 209.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"Empty" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"buildCell"];
    BuildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buildCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:(210.0/255.0) green:(180.0/255.0) blue:(140.0/255.0) alpha:.5]];
    
    NSDictionary *building = [buildings objectAtIndex:[indexPath row]];
    [cell.buildingName setText:[NSString stringWithFormat:@"Name: %@", [building objectForKey:@"name"]]];
    [cell.buildingCost setText:[NSString stringWithFormat:@"Cost: $%d", ((NSNumber*)[building objectForKey:@"cost"]).integerValue]];
    [cell.bonusLabel setText: [NSString stringWithFormat:@"Bonuses: %@", [building objectForKey:@"bonuses"]]];
    
    UIImage *image = [building objectForKey:@"image"];
    [cell.imageOfBuilding setImage:image];
    
    
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
