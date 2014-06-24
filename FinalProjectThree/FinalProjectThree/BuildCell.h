//
//  BuildCell.h
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *buildingName;
@property (weak,nonatomic) IBOutlet UILabel *buildingCost;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfBuilding;
- (IBAction)buyButton:(id)sender;



@end
