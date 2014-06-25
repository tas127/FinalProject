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
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        //initialize all instance variables
        self.money = NSIntegerMax;
        buildmenuup = NO;
        workermenuup = NO;
        xisup = NO;
        
        [self setUpNode];
        
        [self setUpBehindGrid];
        
        [self setUpSeenGrid];
        
        [self setUpBottomBar];
        
        _gameClock = [NSTimer timerWithTimeInterval:120.0 target:self selector:@selector(resetDay) userInfo:nil repeats:YES];
        
        _moneyLabel = [[SKLabelNode alloc] init];
        [_moneyLabel setText: [NSString stringWithFormat:@"$%ld", (long) self.money]];
        [_moneyLabel setFontSize:30];
        [_moneyLabel setFontColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
        [_moneyLabel setZPosition:5.0];
        [_moneyLabel setPosition:CGPointMake(93,50)];
        //[_moneyLabel setHidden:YES];
        [self addChild:_moneyLabel];
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        bool tut = [userDefaults boolForKey:@"tutorial"];
        
        //Set up the entrance to the office
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Hallway"]];
        [[[_gridNodes objectAtIndex:9] objectAtIndex:2] setTexture:texture];
        
        Building *build = [[Building alloc] init];
        [build setBuildType:Hallway];
        
        NSMutableDictionary *defaultSpotHallway = [[_grid objectAtIndex:9] objectAtIndex:2];
        [defaultSpotHallway setValue:build forKey:@"status"];
        [defaultSpotHallway setValue:NO forKey:@"canBuild"];
        
        //Set up a default office for testing:
        SKTexture *textureOffice = [SKTexture textureWithImage:[UIImage imageNamed:@"BasicRight"]];
        [[[_gridNodes objectAtIndex:9] objectAtIndex:1] setTexture:textureOffice];
        
        Building *buildOffice = [[Building alloc] init];
        [buildOffice setBuildType:BasicOffice];
        [buildOffice setDeskOne:NO];
        [buildOffice setDeskTwo:NO];
        [buildOffice setDeskThree:NO];
        [buildOffice setDeskFour:NO];
        
        NSMutableDictionary *defaultSpotOffice = [[_grid objectAtIndex:9] objectAtIndex:1];
        [defaultSpotOffice setValue:buildOffice forKey:@"status"];
        [defaultSpotOffice setValue:NO forKey:@"canBuild"];
        
        //Set up the arrays for buildings and workers
        
        buildings = [[NSMutableArray alloc] init];
        workers = [[NSMutableArray alloc] init];
        
        /*
        if(!tut) {
            [self loadTutorial];
        }*/
        
        
        
        /* Setup your scene here */
        
        //set background color - Grass Green for now - (124,252,0)
        //possibly editable later???
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
    }
    return self;
}
-(void)willMoveFromView:(SKView *)view{
    [_swipeView removeFromSuperview];
}
- (void)didMoveToView:(SKView *)view{
    _swipeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,nodewidth,nodeheight)];
    
    [_swipeView setUserInteractionEnabled:YES];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_swipeView addGestureRecognizer:tap];
    [self.view addSubview:_swipeView];
}

-(void)pan:(UIPanGestureRecognizer*)recognizer{
    CGPoint point = [recognizer translationInView:_swipeView];
    CGPoint next = CGPointMake(_node.position.x + (point.x * 0.1), _node.position.y - (point.y * 0.1));
    float nextx = next.x;
    float nexty = 0;
    
    if(nextx > 0){
        nextx = 0;
    }else if(nextx < -(nodewidth - self.view.frame.size.width)){
        nextx = -(nodewidth - self.view.frame.size.width);
    }
    
    [_node setPosition:CGPointMake(nextx, nexty)];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*bool tut = [userDefaults boolForKey:@"tutorial"];
    if(!tut) {
        [self removeAllChildren];
    }
    */
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        for(int row = 0; row < [_gridNodes count]; row ++) {
            for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col ++) {
                NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                if([[dictionary objectForKey:@"status"] buildType] == BasicOffice) {
                    SKSpriteNode *currentNode = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                    if(CGRectContainsPoint([currentNode frame], location)) {
                        if(CGRectContainsPoint(CGRectMake(37*col + 5, 37 * row + 4, 17, 13), location)) {
                            Worker *worker = [[Worker alloc] initWithImageNamed:@"BasicWorker"];
                            [worker setPosition:CGPointMake(37*col + 5, 37 * row + 4)];
                            [self addChild:worker];
                            [workers addObject:worker];
                        }
                    }
                }
            }
        }
        
        if(CGRectContainsPoint(self.workerButton.frame, location)) {
            workermenuup = YES;
            [self displayTableView];
        } else if(CGRectContainsPoint(self.buildButton.frame, location)) {
            buildmenuup = YES;
            [self displayTableView];
        } else if (CGRectContainsPoint(self.view.frame, location)) {
            if(xisup) {
                [_redxbutton removeFromParent];
            }
            if(workermenuup) {
                [self.tableView removeFromSuperview];
                workermenuup = NO;
            } else if (buildmenuup) {
                [self.buildView removeFromSuperview];
                buildmenuup = NO;
            }
        } else if (xisup && CGRectContainsPoint(_redxbutton.frame, location)) {
            [_redxbutton removeFromParent];
            if(workermenuup) {
                [self.tableView removeFromSuperview];
                workermenuup = NO;
            } else if (buildmenuup) {
                [self.buildView removeFromSuperview];
                buildmenuup = NO;
            }
        }
        
        
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
            Building *build = [[Building alloc] init];
            [build setBuildType:None];
            [build setDeskOne:YES];
            [build setDeskTwo:YES];
            [build setDeskThree:YES];
            [build setDeskFour:YES];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"canBuild" : @YES,
                                                                                                @"status" : build}];
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
            int randnum = arc4random() % 4;
            SKSpriteNode *node;
            switch(randnum) {
                case 0:
                    node = [SKSpriteNode spriteNodeWithImageNamed:@"Grass"];
                    break;
                case 1:
                    node = [SKSpriteNode spriteNodeWithImageNamed:@"Grass2"];
                    break;
                case 2:
                    node = [SKSpriteNode spriteNodeWithImageNamed:@"Grass3"];
                    break;
                case 3:
                    node = [SKSpriteNode spriteNodeWithImageNamed:@"Grass4"];
                    break;
            }
            
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
    
    [self.bottomBar setPosition:CGPointMake(0, 0)];
    [self addChild: _bottomBar];
    [self.bottomBar setZPosition:2.0];
    
    //set up the button to pull up the hire workers menu
    
    int screenwidth = self.frame.size.width;
    int xpos = screenwidth-20;
    int ypos = 45;
    [_workerButton setScale:.25];
    [_workerButton setZPosition:3.0];
    [self.workerButton setPosition:CGPointMake(xpos,ypos)];
    [_bottomBar addChild:_workerButton];
    
    //set up the button to pull up the build menu
    xpos -= 60;
    [_buildButton setScale:.25];
    [_buildButton setZPosition:3.0];
    [_buildButton setPosition:CGPointMake(xpos, ypos)];
    [_bottomBar addChild:_buildButton];
    
    ////////////////////////////////
    // End Setting up bottom bar //
    //////////////////////////////
}

- (void) displayTableView {
    
    if(workermenuup) { //display the cells for the worker menu
        _tableView = [[WorkerView alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width - 50, self.view.frame.size.height - 50)]; //set up a table so that it spawns in the middle of the screen
        //(210,180,140)
        [_tableView setBackgroundColor:[UIColor colorWithRed:(210.0/255.0) green:(180.0/255.0) blue:(140.0/255.0) alpha:1.0]];
        [self.view addSubview:_tableView];
        
        _redxbutton = [[SKSpriteNode alloc] initWithImageNamed:@"RedX"];
        [_redxbutton setPosition:CGPointMake(305,535)];
        [_redxbutton setZPosition:10.0];
        [_redxbutton setScale:.1];
        
        [self addChild:_redxbutton];
        xisup = YES;
        
    } else if (buildmenuup) { //display the cells for the build menu
        _buildView = [[BuildView alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width-50, self.view.frame.size.height-50)];
        [_buildView setBackgroundColor:[UIColor colorWithRed:(210.0/255.0) green:(180.0/255.0) blue:(140.0/255.0) alpha:1.0]];
        [self.view addSubview:_buildView];
        
        _redxbutton = [[SKSpriteNode alloc] initWithImageNamed:@"RedX"];
        [_redxbutton setPosition:CGPointMake(305,535)];
        [_redxbutton setZPosition:10.0];
        [_redxbutton setScale:.1];
        [self addChild:_redxbutton];
        xisup = YES;
    }
}

- (void) resetDay {
    
}

@end
