//
//  Building.h
//  FinalProjectThree
//
//  Created by iD Student on 6/25/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    None,
    Entrance,
    Hallway,
    BasicOffice
} TypeOfBuilding;

@interface Building : SKSpriteNode {
    int myRow;
    int myCol;
}

@property (nonatomic, assign) TypeOfBuilding buildType;
@property (nonatomic, assign) bool deskOne; //top left
@property (nonatomic, assign) bool deskTwo; //top right
@property (nonatomic, assign) bool deskThree; //bottom left
@property (nonatomic, assign) bool deskFour; //bottom right

@property (nonatomic, strong) NSMutableArray *grid; //set to the grid of the scene automatically

@end
