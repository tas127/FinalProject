//
//  Worker.m
//  FinalProjectThree
//
//  Created by iD Student on 6/24/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "Worker.h"



@implementation Worker

- (void) travelRouteHome {
    for(int i = 0; i < [_routeHome count]; i ++) {
        NSDictionary *step = [_routeHome objectAtIndex:i];
        NSString *direction = [step objectForKey:@"direction"];
        NSInteger *pixels = ((NSNumber*)[step objectForKey:@"pixels"]).integerValue;
        int xmovement, ymovement;
        if([direction isEqualToString:@"left"]) {
            ymovement = 0;
            xmovement = -(int)pixels;
        } else if([direction isEqualToString:@"right"])  {
            ymovement = 0;
            xmovement = (int)pixels;
        } else if ([direction isEqualToString:@"up"]) {
            xmovement = 0;
            ymovement = (int)pixels;
        } else if ([direction isEqualToString:@"down"]) {
            xmovement = 0;
            ymovement = -(int)pixels;
        } else {
            xmovement = 0;
            ymovement = 0;
        }
        [self setPosition:CGPointMake(self.position.x + xmovement, self.position.y + ymovement)];
    }
}

- (void) generateRouteHome {
    NSDictionary *toadd;
    if(_doorPos == 1) {
        if(_desk == TopLeft) {
            //go right to be even with the door
            toadd = @{@"direction" : @"right",
                      @"pixels" : @23};
            [_routeHome addObject:toadd];
            //go up to go out the door
            toadd = @{@"direction" : @"up",
                      @"pixels" : @11};
            [_routeHome addObject:toadd];
        }
    }
}

@end
