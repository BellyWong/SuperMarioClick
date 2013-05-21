//
//  Goomba.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Goomba.h"
#import "SuperMarioClick.h"

@implementation Goomba

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos
{
	if ((self = [super init]))
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
        b2BodyDef bodyDef;
		bodyDef.position = [Helper toMeters:pos];
		
		NSString* spriteFrameName = @"Goomba_32.png";
		CCSprite* tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		
		b2CircleShape circleShape;
		float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
		circleShape.m_radius = radiusInMeters;
		
		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &circleShape;
		fixtureDef.density = 0.0f;
		fixtureDef.friction = 0.8f;
        fixtureDef.userData = tempSprite;
		
		// restitution > 1 makes objects bounce off faster than they hit
		fixtureDef.restitution = 1.5f;
		
		sprite.color = ccORANGE;
        
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
	}
	return self;
}

+(id) goombaWithWorld:(b2World*)world position:(CGPoint)pos
{
	return [[[self alloc] initWithWorld:world position:pos] autorelease];
}

@end
