//
//  Ball.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Ball : BodyNode <CCTouchDelegate>
{
	bool moveToFinger;
	CGPoint fingerLocation;
}

+(id) ballWithWorld:(b2World*)world;

+(Ball*) sharedBall;

@end