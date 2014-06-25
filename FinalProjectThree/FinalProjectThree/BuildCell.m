//
//  BuildCell.m
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "BuildCell.h"
#import "MyScene.h"
#import "Global.h"

@implementation BuildCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyButton:(id)sender {
    MyScene *scene = [Global initScene:CGSizeMake(0, 0)];
    if([[self.buildingName text] isEqualToString:@"Name: Hallway"]) {
        [scene reverseHallway];
        [scene collapseTables];
    } else if ([[self.buildingName text] isEqualToString:@"Name: Basic Office"]) {
        [scene reverseBasicOffice];
        [scene collapseTables];
    }
    
}
@end
