//
//  Building.m
//  FinalProjectThree
//
//  Created by iD Student on 6/25/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "Building.h"


@implementation Building



- (void) searchForHallway {
    if(myRow - 1 < [_grid count]) {
        //if([[[[_grid objectAtIndex:myRow-1] objectAtIndex:myCol] valueForKey:@"status"].buildType] == Hallway) {
            
        //}
    }
}

- (void) setRowCol:(int) row column: (int)col {
    myRow = row;
    myCol = col;
}



@end
