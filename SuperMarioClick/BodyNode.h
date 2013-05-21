//
//  BodyNode.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Helper.h"
#import "Constants.h"
#import "SuperMarioClick.h"

@interface BodyNode : CCNode 
{
	b2Body* body;
	CCSprite* sprite;
}

@property (readonly, nonatomic) b2Body* body;
@property (readonly, nonatomic) CCSprite* sprite;

-(void) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName;

-(void) removeSprite;
-(void) removeBody;

@end
