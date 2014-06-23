//
//  MyScene.m
//  FinalProjectThree
//
//  Created by iD Student on 6/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        //initialize all instance variables
        self.money = 0;
        
        [self setUpNode];
        
        [self setUpBehindGrid];
        
        [self setUpSeenGrid];
        
        userDefaults = [NSUserDefaults standardUserDefaults];

        bool tut = [userDefaults boolForKey:@"tutorial"];
        
        /*
        if(!tut) {
            [self loadTutorial];
        }*/
        
        
        
        /* Setup your scene here */
        
        //set background color - Grass Green for now - (124,252,0)
        //possibly editable later???
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        /*
         Save this at least for reference later when making labels for the screen:
         
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
         */
    }
    return self;
}
-(void)willMoveFromView:(SKView *)view{
    [_swipeView removeFromSuperview];
}
- (void)didMoveToView:(SKView *)view{
    _swipeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,nodewidth,nodeheight)];
    
    //_swipeView.center = CGPointMake(_node.position.x + (_node.frame.size.width*.5), _node.position.y + (_node.frame.size.height * .5));
    
    
    
    [_swipeView setUserInteractionEnabled:YES];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_swipeView addGestureRecognizer:tap];
    [self.view addSubview:_swipeView];
   /* UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_swipeView addGestureRecognizer:pan];
    [view addSubview:_swipeView];*/
}

-(void)tapScreen{
    NSLog(@"HIIII");
}


-(void)pan:(UIPanGestureRecognizer*)recognizer{
    CGPoint point = [recognizer translationInView:_swipeView];
    CGPoint next = CGPointMake(_node.position.x + (point.x * 25), _node.position.y - (point.y * .25));
    int nextx = next.x;
    int nexty = next.y;
    if(nextx > 0) {
        [_node setPosition:CGPointMake(0, _node.position.y)];
    } else if (nextx < -(nodewidth*.5)) {
        [_node setPosition:CGPointMake(-(nodewidth*.5), _node.position.y)];
    } else if(nexty < nodeheight) {
        [_node setPosition:CGPointMake(_node.position.x, nodeheight)];
    } else if (nexty > nodeheight * 1.5) {
        [_node setPosition:CGPointMake(_node.position.x, nodeheight*1.5)];
    } else {
        [_node setPosition:CGPointMake(_node.position.x + (point.x*.25), _node.position.y - (point.y*.25))];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*bool tut = [userDefaults boolForKey:@"tutorial"];
    if(!tut) {
        [self removeAllChildren];
    }
    */
    
    for (UITouch *touch in touches) {
        //[_node setPosition:CGPointMake(_node.position.x-10, _node.position.y)];
        /*
         Keep for Reference
         
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];*/
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void) loadTutorial {
    [self removeAllChildren];
    SKSpriteNode *tutorialMan = [SKSpriteNode spriteNodeWithImageNamed:@"TutorialMan"];
    [tutorialMan setScale: .5];
    [tutorialMan setPosition:CGPointMake(35, self.frame.size.height - 50)];
    [self addChild:tutorialMan];
}

- (void) updateMoney {
    //Depending on workers hired, quality of offices, etc, update money based on a certain timer to be set later
}

- (void) setUpNode {
    self.node = [[SKNode alloc] init];
    [self.node setPosition:CGPointMake(0, 0)];
    [self addChild:self.node];
}

- (void) setUpBehindGrid {
    self.grid = [[NSMutableArray alloc] init];
    
    /////////////////////////////////
    // Initialize the behind grid //
    ////////////////////////////////
    
    //put an array in 10 spots of the grid, which will help represent a 10 x 10 grid
    //mutable so possibly user can buy an extension with in-game money?
    //each spot will be tenth of the screen size at the current moment
    for(int i = 0; i < 10; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.grid insertObject:array atIndex:i];
    }
    
    /*
     Put a dictionary at each spot in the grid:
     canBuild: tells the game logic when a user is trying to build something that that something can indeed be built there
     status: tells the game what kind of building is in that spot, in order to use things like upgrades, improvements, etc
     */
    for(int i = 0; i < 10; i ++) {
        for(int k = 0; k < 10; k ++) {
            NSDictionary *dictionary = @{@"canBuild" : @NO,
                                         @"status" : @"nil"};
            [[self.grid objectAtIndex:i] addObject:dictionary];
        }
    }
    
    /////////////////////
    // End behind grid //
    /////////////////////
    
}

- (void) setUpSeenGrid {
    self.gridNodes = [[NSMutableArray alloc] init];
    
    //////////////////////////
    // Initialize seen grid //
    //////////////////////////
    
    //has to be a 2D array
    for(int i = 0; i < 10; i ++) {
        [self.gridNodes insertObject:[[NSMutableArray alloc] init]  atIndex:i];
        for(int k = 0; k < 10; k ++) {
            SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"Grass"];
            [[self.gridNodes objectAtIndex:i] addObject:node];
        }
    }
    
    //Initialize some useful constants:
    double imageWidth = [[[self.gridNodes objectAtIndex:0] objectAtIndex:0] frame].size.width; //image width
    double imageHeight = [[[self.gridNodes objectAtIndex:0] objectAtIndex:0] frame].size.height;
    
    //Calculate the scale so that 10 fit across the screen
    double widthScreen = self.frame.size.width; //width of the screen
    double ratio = imageWidth/widthScreen; //how many images can fit on the screen at the current size
    double scale = .15/ratio; //make the scale so that 10 can fit across
    
    //Scaled useful constants:
    int scaledWidth = imageWidth * scale;
    int scaledHeight = imageHeight * scale;
    
    //display the grid:
    int positionX = scaledWidth * .5; //start the position x at the origin of the image
    int positionY = self.frame.size.height - (scaledHeight * .5); //set the position y at the height minus the origin of the image
    
    //Set the correct positions and add the nodes to the screen
    
    for(int i = 0; i < 10; i ++) {
        positionX = scaledWidth * .5; //reset position x to the origin of the image each time the row is incremented
        
        for(int k = 0; k < 10; k ++) {
            SKSpriteNode *node = [[self.gridNodes objectAtIndex:i] objectAtIndex:k];
            
            [node setPosition:CGPointMake(positionX, positionY)]; //set the correct position
            
            [node setScale:scale];
            
            [_node addChild:node]; //add the image at position (k,i) in the array
            
            positionX += scaledWidth; //increment position x by the size of the image
        }
        positionY -= scaledHeight; //increment position y by the size of the image
    }
    
    ////////////////////
    // End seen grid ///
    ////////////////////
    
    nodeheight = 10 * scaledHeight;
    nodewidth = 10 * scaledWidth;
}

- (void) setUpBottomBar {
    self.bottomBar = [[SKNode alloc] init];
    self.workerButton = [SKSpriteNode spriteNodeWithImageNamed:@"Worker"];
    self.buildButton = [SKSpriteNode spriteNodeWithImageNamed:@"Build"];
    
    ///////////////////////////
    // Set up the bottom bar //
    ///////////////////////////
    
    [self.bottomBar setPosition:CGPointMake(0, self.node.frame.size.height)];
    [self addChild: _bottomBar];
    
    int xpos = _bottomBar.frame.size.width - (1.5 * _workerButton.frame.size.width);
    int ypos = _workerButton.frame.size.height * .5;
    [self.workerButton setPosition:CGPointMake(xpos, ypos)];
    [_bottomBar addChild:_workerButton];
    
}

@end
