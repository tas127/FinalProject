//
//  Worker.h
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    TopLeft = 1,
    TopRight = 2,
    BottomLeft = 3,
    BottomRight = 4
}DeskNum;

@interface Worker : SKSpriteNode

@property (nonatomic, assign) DeskNum desk;
@property (nonatomic, assign) int doorPos; //1 for up, 2 for r, 3 for d, 4 for l
@property (nonatomic, strong) NSMutableArray *routeToBathroom;
@property (nonatomic, strong) NSMutableArray *routeHome; //an array of dictionaries that will specify the route worker must take when traveling to the door and off of the screen
@property (nonatomic, strong) NSString *name;

@end
