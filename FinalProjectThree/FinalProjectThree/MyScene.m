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
        
        NSInteger dollars = [userDefaults integerForKey:@"money"];
        //initialize all instance variables
        if(dollars) {
            self.money = [userDefaults integerForKey:@"money"];
        } else {
            self.money = 100000;
        }
        buildmenuup = NO;
        workermenuup = NO;
        xisup = NO;
        scalefactor = 1;
        
        buildHallway = NO;
        buildBasicOffice = NO;
        destroyActivated = NO;
        workerSelected = YES;
        
        [self setUpNode];
        
        [self setUpBehindGrid];
        
        [self setUpSeenGrid];
        
        [self setUpBottomBar];
        
        _gameClock = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(resetDay) userInfo:nil repeats:YES];
        _moneyTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMoney) userInfo:nil repeats:YES];
        
        _moneyLabel = [[SKLabelNode alloc] init];
        [_moneyLabel setText: [NSString stringWithFormat:@"$%ld", (long) self.money]];
        [_moneyLabel setFontSize:30];
        [_moneyLabel setFontColor:[UIColor whiteColor]];
        [_moneyLabel setZPosition:5.0];
        [_moneyLabel setPosition:CGPointMake(170, 520)];

        //[_moneyLabel setHidden:YES];
        [self addChild:_moneyLabel];
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:self.money forKey:@"money"];
        
        //bool tut = [userDefaults boolForKey:@"tutorial"];
        
        //Set up the entrance to the office
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Hallway"]];
        [[[_gridNodes objectAtIndex:9] objectAtIndex:2] setTexture:texture];
        
        Building *build = [[Building alloc] init];
        [build setBuildType:Hallway];
        
        NSMutableDictionary *defaultSpotHallway = [[_grid objectAtIndex:9] objectAtIndex:2];
        [defaultSpotHallway setValue:build forKey:@"status"];
        NSNumber *num = [[NSNumber alloc] initWithBool:NO];
        [defaultSpotHallway setValue:num forKey:@"canBuild"];
        
        //Set up a default office for testing:
        SKTexture *textureOffice = [SKTexture textureWithImage:[UIImage imageNamed:@"BasicRight"]];
        [[[_gridNodes objectAtIndex:9] objectAtIndex:1] setTexture:textureOffice];
        
        Building *buildOffice = [[Building alloc] init];
        [buildOffice setBuildType:BasicOffice];
        [buildOffice setNumWorkers:0];
        [buildOffice setDirection:R];

        
        NSMutableDictionary *defaultSpotOffice = [[_grid objectAtIndex:9] objectAtIndex:1];
        [defaultSpotOffice setValue:buildOffice forKey:@"status"];
        num = [[NSNumber alloc] initWithBool:NO];
        [defaultSpotOffice setValue:num forKey:@"canBuild"];
        numOffices = 1;
        numHallways = 1;
        
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
    UIPinchGestureRecognizer *pincher = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [_swipeView addGestureRecognizer:tap];
    [_swipeView addGestureRecognizer:pincher];
    [self.view addSubview:_swipeView];
}

- (void) pinch:(UIPinchGestureRecognizer*)recognizer{
    if([recognizer state] == UIGestureRecognizerStateChanged) {
        [_node setPosition:CGPointMake(_node.position.x, 0)];
        [_node setScale:_node.xScale * recognizer.scale];
        if (_node.xScale < 1) {
            [_node setScale:1];
        }
    }
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        [_node setPosition:CGPointMake(_node.position.x, 0)];
    }
    scalefactor = _node.xScale;
    if(scalefactor > 20) {
        [_node setScale:20];
    }
    NSLog(@"%f", scalefactor);
}



-(void)pan:(UIPanGestureRecognizer*)recognizer{
    CGPoint point = [recognizer translationInView:_swipeView];
    CGPoint next = CGPointMake(_node.position.x + (point.x * 0.1), _node.position.y - (point.y * 0.1));
    float nextx = next.x;
    float nexty = next.y;
    
    if(nextx > 0){
        nextx = 0;
    }else if(nextx < -(nodewidth - self.view.frame.size.width)){
        nextx = -(nodewidth - self.view.frame.size.width);
    }
    if (nexty > nodeheight - self.view.frame.size.height + (_workerButton.frame.size.height +25)) {
        nexty = nodeheight - self.view.frame.size.height + (_workerButton.frame.size.height +25);
    } else if (nexty < 0) {
        nexty = 0;
    }
    //NSLog(@"%f, %f", nextx, nexty);
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
        /*
        for(int row = 0; row < [_gridNodes count]; row ++) {
            for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col ++) {
                NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                if([[dictionary objectForKey:@"status"] buildType] == BasicOffice) {
                    SKSpriteNode *currentNode = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                    CGPoint point = CGPointMake(location.x - _node.position.x, location.y - _node.position.y);
                    if(CGRectContainsPoint([currentNode frame], point)) {
                        if(CGRectContainsPoint(CGRectMake(37*col + 5, 37 * row + 4, 17, 13), location)) {
                            Worker *worker = [[Worker alloc] initWithImageNamed:@"BasicWorker"];
                            [worker setPosition:CGPointMake(37*col + 5, 37 * row + 4)];
                            [worker setZPosition:10.0];
                            [self addChild:worker];
                            [workers addObject:worker];
                        }
                    }
                }
            }
        }*/
        if(CGRectContainsPoint(self.workerButton.frame, location)) {
            workermenuup = YES;
            [self displayTableView];
        } else if(CGRectContainsPoint(self.buildButton.frame, location)) {
            buildmenuup = YES;
            [self displayTableView];
        } else if (CGRectContainsPoint(self.view.frame, location)) {
            [self collapseTables];
        } else if (xisup && CGRectContainsPoint(_redxbutton.frame, location)) {
            [self collapseTables];
        }
        
        if(CGRectContainsPoint(self.destroyButton.frame, location)) {
            destroyActivated = !destroyActivated;
        }
        
        /*if(CGRectContainsPoint(self.cheaterButton.frame, location)) {
            CGPoint point = CGPointMake(location.x - _node.position.x, location.y - _node.position.y);
            _cheatText = [[UITextField alloc] initWithFrame:CGRectMake(_swipeView.frame.size.width * .5, _swipeView.frame.size.height * .5, 100, 50)];
            [_swipeView addSubview:_cheatText];
        }*/
        
        if(workerSelected) {
            for(int row = 0; row < [_gridNodes count]; row ++) {
                for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col ++) {
                    CGPoint point = CGPointMake(location.x-_node.position.x, location.y-_node.position.y);
                    NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                    SKSpriteNode *node = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                    if(CGRectContainsPoint(node.frame, point)) {
                        Building *build = [dictionary objectForKey:@"status"];
                        if([build buildType] == BasicOffice) {
                            int curWorkers = [build numWorkers];
                            if(curWorkers < 5) {
                                Facing f = [build direction];
                                SKTexture *texture;
                                if(curWorkers == 0) {
                                    [build setNumWorkers:1];
                                    texture = [SKTexture textureWithImage:[UIImage imageNamed:@"BasicOne"]];
                                    [node setTexture:texture];
                                    if (f == R) {
                                        [node setZRotation:(3*M_PI)/2];
                                    } else if (f == D) {
                                        [node setZRotation:M_PI];
                                    } else if (f == L) {
                                        [node setZRotation:M_PI/2.0];
                                    }
                                }
                            } else {
                                workerSelected = NO;
                            }
                        }
                    }
                }
            }
        }
        
        if(destroyActivated) {
            for(int row = 0; row < [_gridNodes count]; row ++) {
                for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col ++) {
                    NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                    SKSpriteNode *node = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                    CGPoint point = CGPointMake(location.x - _node.position.x, location.y - _node.position.y);
                    if(CGRectContainsPoint(node.frame, point)) {
                        NSNumber *b = [dictionary objectForKey:@"canBuild"];
                        if(!b.boolValue) {
                            int randnum = arc4random() % 4;
                            SKTexture *texture;
                            switch(randnum) {
                                case 0:
                                    texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Grass"]];
                                    break;
                                case 1:
                                    texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Grass2"]];
                                    break;
                                case 2:
                                    texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Grass3"]];
                                    break;
                                case 3:
                                    texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Grass4"]];
                                    break;
                            }
                            if([[dictionary objectForKey:@"status"] buildType] == BasicOffice) {
                                numOffices --;
                            } else if ([[dictionary objectForKey:@"status"] buildType] == Hallway) {
                                numHallways--;
                            }
                            [node setTexture:texture];
                            NSNumber *num = [[NSNumber alloc] initWithBool:YES];
                            [dictionary setValue:num forKey:@"canBuild"];
                            Building *build = [[Building alloc] init];
                            [build setBuildType:None];
                            [dictionary setValue:build forKey:@"status"];
                            destroyActivated = NO;
                            

                        }
                    }
                }
            }
        }
        
        if(buildHallway) {
            if(self.money >= 100) {
                for(int row = 0; row < [_gridNodes count]; row++) { //loop through the rows of the array starting in the top
                    for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col++) { //loop through the cols of the array starting in the left
                        NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                        SKSpriteNode *node = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                        CGPoint point = CGPointMake(location.x - _node.position.x,location.y - _node.position.y);
                        if(CGRectContainsPoint(node.frame, point)) {
                            if([self bordersHallwayWithRow:row Column:col]) {
                                NSNumber *num = [dictionary objectForKey:@"canBuild"];
                                if(num.boolValue) {
                                    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"Hallway"]];
                                    [node setTexture:texture];
                                     Building *build = [dictionary objectForKey:@"status"];
                                     [build setBuildType:Hallway];
                                     [dictionary setValue:NO forKey:@"canBuild"];
                                     NSLog(@"Placed a node at: (%d,%d)!",row,col);
                                     [self reverseHallway];
                                     self.money -= 100;
                                    numHallways++;
                                }
                            }
                        }
                    }
                }
            } else {
                [self reverseBasicOffice];
                _youCantDoThat = [[SKLabelNode alloc] init];
                [_youCantDoThat setText:@"You don't have enough money for that!"];
                [_youCantDoThat setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
                [_youCantDoThat setZPosition:10.0];
                [_youCantDoThat setFontSize:15];
                [_youCantDoThat setPosition:CGPointMake(.5 * self.view.frame.size.width, .5 * self.view.frame.size.height)];
                [self addChild:_youCantDoThat];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(deleteYouCantDoThat) userInfo:nil repeats:NO];
                
                _fadeText = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(fadeYCDT) userInfo:nil repeats:YES];
            }

            
        }
        
        if(buildBasicOffice) {
            if(self.money >= 500) {
                for(int row = 0; row < [_gridNodes count]; row++) { //loop through the rows of the array starting in the top
                    for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col++) { //loop through the cols of the array starting in the left
                        NSMutableDictionary *dictionary = [[_grid objectAtIndex:row] objectAtIndex:col];
                        SKSpriteNode *node = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                        CGPoint point = CGPointMake(location.x - _node.position.x,location.y - _node.position.y);
                        if(CGRectContainsPoint(node.frame, point)) {
                            if([self bordersHallwayWithRow:row Column:col]) {
                                NSNumber *num = [dictionary objectForKey:@"canBuild"];
                                if(num.boolValue) {
                                    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"BasicUp"]];
                                    Direction d = [self directionToHallwayRow:row Column:col];
                                    Building *build = [dictionary objectForKey:@"status"];
                                    [build setBuildType:BasicOffice];
                                    [build setNumWorkers:0];
                                    if(d == Up) {
                                        [build setDirection:U];
                                    } else if (d == Right) {
                                        [node setZRotation:(3*M_PI)/2];
                                        [build setDirection:R];
                                    } else if (d == Left) {
                                        [node setZRotation:(M_PI/2)];
                                        [build setDirection:L];
                                    } else {
                                        [node setZRotation:M_PI];
                                        [build setDirection:D];
                                    }
                                    [node setTexture:texture];
                                    [dictionary setValue:NO forKey:@"canBuild"];
                                    NSLog(@"Placed a node at: (%d,%d)!",row,col);
                                    [self reverseBasicOffice];
                                    self.money -= 500;
                                    numOffices++;
                                }
                            }
                        }
                    }
                }
            } else {
                [self reverseBasicOffice];
                _youCantDoThat = [[SKLabelNode alloc] init];
                [_youCantDoThat setText:@"You don't have enough money for that!"];
                [_youCantDoThat setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
                [_youCantDoThat setZPosition:10.0];
                [_youCantDoThat setFontSize:15];
                [_youCantDoThat setPosition:CGPointMake(.5 * self.view.frame.size.width, .5 * self.view.frame.size.height)];
                [self addChild:_youCantDoThat];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(deleteYouCantDoThat) userInfo:nil repeats:NO];
                
                _fadeText = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(fadeYCDT) userInfo:nil repeats:YES];
            }
        }

        
        
        /*
        for(int row = 0; row < [_gridNodes count]; row++) { //loop through the rows of the array starting in the top
            for(int col = 0; col < [[_gridNodes objectAtIndex:row] count]; col++) { //loop through the cols of the array starting in the left
                CGPoint point = CGPointMake(location.x - _node.position.x,location.y - _node.position.y);
                SKNode *node = [[_gridNodes objectAtIndex:row] objectAtIndex:col];
                if(CGRectContainsPoint(node.frame, point)) {
                    Worker *worker = [[Worker alloc] initWithImageNamed:@"BasicWorker"];
                    [worker setPosition:CGPointMake(point.x, point.y)];
                    [self addChild:worker];
                }
            }
        }*/
        
        
        
        
    }
}

- (void) fadeYCDT {
    [_youCantDoThat setAlpha:_youCantDoThat.alpha -= .1];
}

- (void) deleteYouCantDoThat {
    [_youCantDoThat removeFromParent];
    [_fadeText invalidate];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [_moneyLabel setText:[NSString stringWithFormat:@"$%d",self.money]];
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
    self.money += (numOffices * 4);
    [userDefaults setInteger:self.money forKey:@"money"];
    [userDefaults synchronize];
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

            
            NSNumber *num = [[NSNumber alloc] initWithBool:YES];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"canBuild" : num,
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
    double scale = .3/ratio; //make the scale so that 10 can fit across
    
    oldratio = .15/ratio;
    oldratio *= imageHeight;
    oldratio *= 10;
    
    //Scaled useful constants:
    int scaledWidth = imageWidth * scale; // .15/ratio is the old
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
    _destroyButton = [SKSpriteNode spriteNodeWithImageNamed:@"Bulldozer"];
    //_cheaterButton = [SKSpriteNode spriteNodeWithImageNamed:@"Cheater"];
    
    ///////////////////////////
    // Set up the bottom bar //
    ///////////////////////////
    
    [self.bottomBar setPosition:CGPointMake(0, 0)];
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] size:CGSizeMake(self.view.frame.size.width, oldratio)];
    [node setPosition:CGPointMake(0, 0)];
    [node setZPosition:3.0];
    [self addChild: _bottomBar];
    [self.bottomBar setZPosition:2.0];
    [self.bottomBar addChild:node];
    //set up the button to pull up the hire workers menu
    
    int screenwidth = self.frame.size.width;
    int xpos = screenwidth-20;
    int ypos = 45;
    [_workerButton setScale:.25];
    [_workerButton setZPosition:4.0];
    [self.workerButton setPosition:CGPointMake(xpos,ypos)];
    [_bottomBar addChild:_workerButton];
    
    //set up the button to pull up the build menu
    xpos -= 60;
    [_buildButton setScale:.25];
    [_buildButton setZPosition:4.0];
    [_buildButton setPosition:CGPointMake(xpos, ypos)];
    [_bottomBar addChild:_buildButton];
    
    xpos -= 80;
    [_destroyButton setScale:.75];
    [_destroyButton setZPosition:4.0];
    [_destroyButton setPosition:CGPointMake(xpos,ypos)];
    [_bottomBar addChild:_destroyButton];
    
    /*xpos -= 80;
    [_cheaterButton setScale:.25];
    [_cheaterButton setZPosition:4.0];
    [_cheaterButton setPosition:CGPointMake(xpos, ypos)];
    [_bottomBar addChild:_cheaterButton];*/
    
    ////////////////////////////////
    // End Setting up bottom bar //
    //////////////////////////////
}

- (void) displayTableView {
    
    if(workermenuup) { //display the cells for the worker menu
        if(buildHallway) {
            [self reverseHallway];
        }
        if(buildBasicOffice) {
            [self reverseBasicOffice];
        }
        
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
        if(buildHallway) {
            [self reverseHallway];
        }
        if(buildBasicOffice) {
            [self reverseBasicOffice];
        }
        
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

- (void) collapseTables {
    if(workermenuup) {
        [_tableView removeFromSuperview];
        workermenuup = NO;
    }
    if(xisup) {
        [_redxbutton removeFromParent];
        xisup = NO;
    }
    if(buildmenuup) {
        [_buildView removeFromSuperview];
        buildmenuup = NO;
    }
}

- (void) resetDay {
    
}

- (void) reverseHallway {
    buildHallway = !buildHallway;
}

- (void) reverseBasicOffice {
    buildBasicOffice = !buildBasicOffice;
}

- (void) reverseDestruction {
    destroyActivated = !destroyActivated;
}

- (BOOL) getDestruction {
    return destroyActivated;
}

- (bool) bordersHallwayWithRow:(int)row Column:(int)col {
    if(row - 1 >= 0) {
        if([[[[_grid objectAtIndex:row-1] objectAtIndex:col] objectForKey:@"status"] buildType] == Hallway) {
            return true;
        }
    }
    int c = col - 1;
    for(; c <= col + 1; c++) {
        if(c >= 0 && c < [_grid count]) {
            Building *build = [[[_grid objectAtIndex:row] objectAtIndex:c] objectForKey:@"status"];
            if([build buildType] == Hallway) {
                return true;
             }
        }
    }
    if(row + 1 < [_grid count]) {
        Building *build = [[[_grid objectAtIndex:row+1] objectAtIndex:col] objectForKey:@"status"];
        if([build buildType] == Hallway) {
            return true;
        }
    }
    return false;
}

- (Direction) directionToHallwayRow:(int)row Column:(int)col {
    if(row - 1 >= 0) {
        if([[[[_grid objectAtIndex:row-1] objectAtIndex:col] objectForKey:@"status"] buildType] == Hallway) {
            return Up;
        }
    }
    
    if(col - 1 >= 0) {
        Building *build = [[[_grid objectAtIndex:row] objectAtIndex:col-1] objectForKey:@"status"];
        if([build buildType] == Hallway) {
            return Left;
        }
    }
    
    if(col + 1 < [_grid count]) {
        Building *build = [[[_grid objectAtIndex:row] objectAtIndex:col+1] objectForKey:@"status"];
        if([build buildType] == Hallway) {
            return Right;
        }
    }
    
    if(row + 1 < [_grid count]) {
        Building *build = [[[_grid objectAtIndex:row+1] objectAtIndex:col] objectForKey:@"status"];
        if([build buildType] == Hallway) {
            return Down;
        }
    }
    return Here;
}

@end
