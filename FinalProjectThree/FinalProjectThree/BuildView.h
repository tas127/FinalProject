//
//  BuildView.h
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildCell.h"

@interface BuildView : UITableView <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *buildings;
}

@end
