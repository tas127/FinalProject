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
@property (nonatomic, strong) NSMutableArray *routeToBathroom;
@property (nonatomic, strong) NSMutableArray *routeHome; //an array of dictionaries that will specify the route my little worker must take when traveling to the door and off of the screen
@property (nonatomic, strong) NSString *name;

@end
