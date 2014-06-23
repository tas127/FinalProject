//
//  MyScene.h
//  FinalProjectThree
//

//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene {
    bool tutorialTime; //tells the game if it is the user's first time playing the game, if not load their current game
    /*
    Will store things such as ... 
        tutorialTime
        gameProgress
        etc ... 
     */
    NSUserDefaults *userDefaults;
}

@property (nonatomic, assign) int money;
@property (nonatomic, strong) NSMutableArray *grid;
@property (nonatomic, strong) NSMutableArray *gridNodes;
@property (nonatomic, strong) NSTimer *moneyTimer; //to track money adding to the business, possibly can increase speed?


@end
