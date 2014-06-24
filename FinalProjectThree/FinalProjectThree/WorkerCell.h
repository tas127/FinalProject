//
//  WorkerCell.h
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScene.h"

@interface WorkerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *moneyMadeLabel;
@property (nonatomic,weak) IBOutlet UILabel *moneyCostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfWorker;

@end
