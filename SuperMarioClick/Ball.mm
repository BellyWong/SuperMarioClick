//
//  Ball.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "Constants.h"
#import "Helper.h"
#import "SuperMarioClick.h"

@interface Ball (PrivateMethods)
-(void) createBallInWorld:(b2World*)world;
@end


@implementation Ball

static Ball* ballInstance;
+(Ball *)sharedBall
{
    return ballInstance;
}

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
		[self createBallInWorld:world];
		
//		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        ballInstance = self;
		
		[self scheduleUpdate];
	}
	return self;
}

+(id) ballWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) dealloc
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super dealloc];
}

-(void) createBallInWorld:(b2World*)world
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	float randomOffset = CCRANDOM_0_1() * 10.0f - 5.0f;
	CGPoint startPos = CGPointMake(screenSize.width/2 + randomOffset, 400);
	
	// Create a body definition and set it to be a dynamic body
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:startPos];
	bodyDef.angularDamping = 0.9f;
	
	NSString* spriteFrameName = @"magic_ball.png";
	CCSprite* tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	
	b2CircleShape shape;
	float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
	shape.m_radius = radiusInMeters;
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 0.8f;
	fixtureDef.friction = 0.7f;
	fixtureDef.restitution = 0.8f;
	
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
	
	sprite.color = ccRED;
}

-(void) applyForceTowardsFinger
{
	b2Vec2 bodyPos = body->GetWorldCenter();
	b2Vec2 fingerPos = [Helper toMeters:fingerLocation];
	
	b2Vec2 bodyToFinger = fingerPos - bodyPos;
	float distance = bodyToFinger.Normalize();
	
	// "Real" gravity falls off by the square over distance. Feel free to try it this way:
	//float distanceSquared = distance * distance;
	//b2Vec2 force = ((1.0f / distanceSquared) * 20.0f) * bodyToFinger;
	
	b2Vec2 force = 10.0f * bodyToFinger;
	body->ApplyForce(force, body->GetWorldCenter());
}

-(void) update:(ccTime)delta
{
	if (moveToFinger == YES)
	{
		// disabled: not needed anymore
		//[self applyForceTowardsFinger];
	}
	
	if (sprite.position.y <= (sprite.contentSize.height))
	{
		// create a new ball and remove the old one
        [[SuperMarioClick sharedSuperMario]setContactCount:0];
		//[self createBallInWorld:body->GetWorld()];
	}
}

// game reset
-(void) gameReset{
    [self createBallInWorld:body->GetWorld()];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	moveToFinger = YES;
	fingerLocation = [Helper locationFromTouch:touch];
	return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	fingerLocation = [Helper locationFromTouch:touch];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	moveToFinger = NO;
}


@end
