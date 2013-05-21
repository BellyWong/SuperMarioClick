//
//  WorldInitialize.m
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WorldInitialize.h"
#import "Constants.h"
#import "Helper.h"
#import "Goomba.h"
#import "Ball.h"
#import "MashRoom.h"

@interface WorldInitialize (PrivateMethods)
-(void) addGoombaAt:(CGPoint)pos;
-(void) createTableTopBody;
@end


@implementation WorldInitialize

-(id) initMarioWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
		// weak reference to world for convenience
		world_ = world;
		
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"table.png"];
		[self addChild:batch];
        [self addGoombaAt:CGPointMake(150, 330)];
		[self addGoombaAt:CGPointMake(100, 390)];
		[self addGoombaAt:CGPointMake(230, 380)];
		[self addGoombaAt:CGPointMake(40, 350)];
               
		MashRoom* mashRoom = [MashRoom mashRoomWithWorld:world];
		[self addChild:mashRoom z:-2];
		
		Ball* ball = [Ball ballWithWorld:world];
		[self addChild:ball z:-1];
		
		// world is no longer needed after init:
		world_ = NULL;
	}
	
	return self;
}

+(id) setupMarioWithWorld:(b2World*)world
{
	return [[[self alloc] initMarioWithWorld:world] autorelease];
}

-(void) addGoombaAt:(CGPoint)pos
{
	Goomba* goomba = [Goomba goombaWithWorld:world_ position:pos];
	[self addChild:goomba];
}

-(void) createStaticBodyWithVertices:(b2Vec2[])vertices numVertices:(int)numVertices
{
	// Create a body definition 
	b2BodyDef bodyDef;
	bodyDef.position = [Helper toMeters:[Helper screenCenter]];
	
	b2PolygonShape shape;
	shape.Set(vertices, numVertices);
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.2f;
	fixtureDef.restitution = 0.1f;
    
	b2Body* body = world_->CreateBody(&bodyDef);
	body->CreateFixture(&fixtureDef);
}

-(void) createTableTopBody
{
    //row 1, col 1
	int num = 4;
    b2Vec2 vertices[] = {
        b2Vec2(159.5f / PTM_RATIO, 239.5f / PTM_RATIO),
        b2Vec2(-159.5f / PTM_RATIO, 239.5f / PTM_RATIO),
        b2Vec2(-159.9f / PTM_RATIO, 239.0f / PTM_RATIO),
        b2Vec2(159.0f / PTM_RATIO, 239.0f / PTM_RATIO)
    };
    [self createStaticBodyWithVertices:vertices numVertices:num];
}

@end
