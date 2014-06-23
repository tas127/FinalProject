//
//  MyScene.h
//  FinalProjectThree
//

//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <UIGestureRecognizerDelegate>{
    bool tutorialTime; //tells the game if it is the user's first time playing the game, if not load their current game
    /*
    Will store things such as ... 
        tutorialTime
        gameProgress
        etc ... 
     */
    NSUserDefaults *userDefaults;
    int nodewidth;
    int nodeheight;
}

@property (nonatomic, assign) int money;
@property (nonatomic, strong) NSMutableArray *grid;
@property (nonatomic, strong) NSMutableArray *gridNodes;
@property (nonatomic, strong) NSTimer *moneyTimer; //to track money adding to the business, possibly can increase speed?
@property (nonatomic, strong) SKNode *node;
@property (nonatomic, strong) SKNode *bottomBar;
@property (nonatomic, strong) SKSpriteNode *buildButton;
@property (nonatomic, strong) SKSpriteNode *workerButton;

@property (nonatomic, strong) UIView *swipeView;


@end
