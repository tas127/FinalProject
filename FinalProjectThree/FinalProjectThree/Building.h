//
//  Building.h
//  FinalProjectThree
//
//  Created by iD Student on 6/25/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Global.h"

typedef enum {
    None,
    Entrance,
    Hallway,
    BasicOffice
} TypeOfBuilding;

typedef enum {
    U,
    R,
    L,
    D
}Facing;


@interface Building : SKSpriteNode {
    int myRow;
    int myCol;
}

@property (nonatomic, assign) TypeOfBuilding buildType;


@property (nonatomic, strong) NSMutableArray *grid; //set to the grid of the scene automatically
@property (nonatomic, assign) Facing direction;
@property (nonatomic, assign) int numWorkers;

@end
