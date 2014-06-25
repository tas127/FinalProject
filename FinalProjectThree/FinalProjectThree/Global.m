//
//  Global.m
//  FinalProjectThree
//
//  Created by iD Student on 6/25/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "Global.h"
static MyScene *myScene;
@implementation Global
+(id)initScene:(CGSize) size{
    if(myScene == nil)
        myScene = [[MyScene alloc] initWithSize:size];
    return myScene;
}
@end
