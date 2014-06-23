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
        
        self.grid = [[NSMutableArray alloc] init];
        self.gridNodes = [[NSMutableArray alloc] init];
        userDefaults = [NSUserDefaults standardUserDefaults];
        bool tut = [userDefaults boolForKey:@"tutorial"];
        
        /*
        if(!tut) {
            [self loadTutorial];
        }*/
        
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
        
        //////////////////////////
        // Initialize seen grid //
        //////////////////////////
        
        //has to be a 2D array
        for(int i = 0; i < 10; i ++) {
            [self.gridNodes insertObject:[[NSMutableArray alloc] init]  atIndex:i];
        }
        
        for(int i = 0; i < 10; i ++) {
            for(int k = 0; k < 10; k ++) {
                SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"TutorialMan"];
                [[self.gridNodes objectAtIndex:i] addObject:node];
            }
        }
        
        //display the grid:
        int positionX = [[[self.gridNodes objectAtIndex:0] objectAtIndex:0] frame].size.width * .5; //start the position x at the origin of the image
        int positionY = self.frame.size.height - ([[[self.gridNodes objectAtIndex:0] objectAtIndex:0]frame].size.height * .5); //set the position y at the height minus the origin of the image
        for(int i = 0; i < 10; i ++) {
            positionX = [[[self.gridNodes objectAtIndex:0] objectAtIndex:0]frame].size.width * .5; //reset position x to the origin of the image each time the row is incremented
            for(int k = 0; k < 10; k ++) {
                [[[self.gridNodes objectAtIndex:i] objectAtIndex:k] setPosition:CGPointMake(positionX, positionY)]; //set the correct position
                
                //Set the Scale using mathing
                double widthScreen = self.frame.size.width;
                double imageWidth = [[[self.gridNodes objectAtIndex:i] objectAtIndex:k] frame].size.width;
                double ratio = imageWidth/widthScreen;
                double scale = .1/ratio;
                [[[self.gridNodes objectAtIndex:i] objectAtIndex:k] setScale:scale];
                
                [self addChild:[[self.gridNodes objectAtIndex:i] objectAtIndex:k]]; //add the image at position (k,i) in the array
                
                positionX += [[[self.gridNodes objectAtIndex:0] objectAtIndex:0] frame].size.width; //increment position x by the size of the image
            }
            positionY -= [[[self.gridNodes objectAtIndex:0] objectAtIndex:0] frame].size.height; //increment position y by the size of the image
        }
        
        
        /* Setup your scene here */
        
        //set background color - Grass Green for now - (124,252,0)
        //possibly editable later???
        self.backgroundColor = [SKColor colorWithRed:(124.0/255.0) green:(252.0/255.0) blue:0.0 alpha:1.0];
        
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    bool tut = [userDefaults boolForKey:@"tutorial"];
    if(!tut) {
        [self removeAllChildren];
    }
    
    
    for (UITouch *touch in touches) {
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

@end
