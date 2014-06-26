//
//  MyScene.h
//  FinalProjectThree
//

//  Copyright (c) 2014 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WorkerView.h"
#import "WorkerCell.h"
#import "BuildView.h"
#import "Building.h"
#import "Worker.h"

typedef  enum {
    Here,
    Up,
    Right,
    Left,
    Down
}Direction;

@interface MyScene : SKScene <UIGestureRecognizerDelegate> {
    bool tutorialTime; //tells the game if it is the user's first time playing the game, if not load their current game
    /*
    Will store things such as ... 
        tutorialTime
        gameProgress
        grid
        numWorkers
        workers
        ...
        etc ... 
     */
    NSUserDefaults *userDefaults;
    int nodewidth;
    int nodeheight;
    //bools that help the logic when detecting taps
    bool buildmenuup;
    bool workermenuup;
    bool xisup;
    
    NSMutableArray *buildings;
    NSMutableArray *workers;
    
    double oldratio;
    
    double scalefactor;
    
    //bools to judge what to build
    bool buildHallway;
    bool buildBasicOffice;
    bool destroyActivated;
    
    int numOffices;
    int numHallways;
    
}

//primitives that need methods
@property (nonatomic, assign) NSInteger money;

//mutable arrays to keep track of the grid
@property (nonatomic, strong) NSMutableArray *grid;
@property (nonatomic, strong) NSMutableArray *gridNodes;

//timers to keep track of money adding, game clock, etc
@property (nonatomic, strong) NSTimer *moneyTimer; //to track money adding to the business, possibly can increase speed?
@property (nonatomic, strong) NSTimer *gameClock; //to track the time of day
@property (nonatomic, strong) NSTimer *fadeText;

//nodes to make the bottom bar and the map separate
@property (nonatomic, strong) SKNode *node;
@property (nonatomic, strong) SKNode *bottomBar;

//sprite nodes for things such as buttons, etc
@property (nonatomic, strong) SKSpriteNode *buildButton;
@property (nonatomic, strong) SKSpriteNode *workerButton;
@property (nonatomic, strong) SKSpriteNode *destroyButton;

//labels
@property (nonatomic, strong) SKLabelNode *timeLabel;
@property (nonatomic, strong) SKLabelNode *moneyLabel;
@property (nonatomic, strong) SKLabelNode *youCantDoThat;

//temporary views for things such as ...
//      swiping
//      displaying the menu to buy workers and buildings in
@property (nonatomic, strong) UIView *swipeView;
@property (nonatomic, strong) WorkerView *tableView;
@property (nonatomic, strong) BuildView *buildView;

//temporary buttons ...
@property (nonatomic, strong) UIImageView *redx;
@property (nonatomic, strong) SKSpriteNode *redxbutton;
@property (nonatomic, strong) SKSpriteNode *menu;

-(void)reverseHallway;
-(void)reverseBasicOffice;
-(void)collapseTables;
-(bool) bordersHallwayWithRow:(int)row Column:(int)col;
-(Direction)directionToHallwayRow:(int)row Column:(int)col;
- (BOOL) getDestruction;
- (void) reverseDestruction;

@end
