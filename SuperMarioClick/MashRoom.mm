//
//  MashRoom.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MashRoom.h"
#import "SuperMarioClick.h"

@interface MashRoom (PrivateMethods)
-(void) attachPlunger;
@end


@implementation MashRoom

@synthesize doPlunge;
@synthesize sharedMashRoomBody;
@synthesize shareMashRoomFixture;

static MashRoom* mashRoomInstance;

+(MashRoom*) sharedMashRoom
{
	NSAssert(mashRoomInstance != nil, @"table not yet initialized!");
	return mashRoomInstance;
}

-(void)setBody:(b2Body*)body{
    sharedMashRoomBody = body;
}

-(void)setFixture:(b2Fixture*)fixture
{
    shareMashRoomFixture = fixture;
    
}

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
        mashRoomInstance = self;
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		CGPoint plungerPos = CGPointMake(screenSize.width - 13, 32);
		
		// Create a body definition
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = [Helper toMeters:plungerPos];
	 
        b2CircleShape shape;
        float radiusInMeters = (50 / PTM_RATIO) * 0.5f;
        shape.m_radius = radiusInMeters;
		
		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &shape;
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.99f;
		fixtureDef.restitution = 0.01f;
		
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"Mushroom_32.png"];
		
		sprite.position = plungerPos;
		
		[self scheduleUpdate];
	}
	return self;
}

+(id) mashRoomWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) endPlunge:(ccTime)delta
{
	[self unschedule:_cmd];
	joint->EnableMotor(NO);
}

-(void) update:(ccTime)delta
{
    //	if (doPlunge == YES)
    //	{
    //		doPlunge = NO;
    //		joint->EnableMotor(YES);
    //
    //		// schedule motor to come back, unschedule in case the plunger is hit repeatedly within a short time
    //		[self unschedule:_cmd];
    //		[self schedule:@selector(endPlunge:) interval:0.5f];
    //	}
}

@end

