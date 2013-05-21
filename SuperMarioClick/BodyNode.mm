//
//  BodyNode.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
#import "MashRoom.h"


@implementation BodyNode

@synthesize body;
@synthesize sprite;

-(void) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
	
	[self removeSprite];
	[self removeBody];
	
	CCSpriteBatchNode* batch = [[SuperMarioClick sharedSuperMario] getSpriteBatch];
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	[batch addChild:sprite];
    
    //sprite.opacity = 0;
	
    body = world->CreateBody(bodyDef);
    if(spriteFrameName == @"Mushroom_32.png")
    {
        [[MashRoom sharedMashRoom ]setBody:body];
        
    }
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
        b2Fixture* temp = body->CreateFixture(fixtureDef);
        if(spriteFrameName == @"Mushroom_32.png")
        {
            [[MashRoom sharedMashRoom]setFixture:temp];
        }
	}
}

-(void) removeSprite
{
	CCSpriteBatchNode* batch = [[SuperMarioClick sharedSuperMario] getSpriteBatch];
	if (sprite != nil && [batch.children containsObject:sprite])
	{
        [sprite removeFromParentAndCleanup:YES];
		[batch.children removeObject:sprite];
		sprite = nil;
	}
}

-(void) removeBody
{
	if (body != NULL)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}

-(void) dealloc
{
	[self removeSprite];
	[self removeBody];
	
	[super dealloc];
}

@end
