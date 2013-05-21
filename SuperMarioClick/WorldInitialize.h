//
//  WorldInitialize.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface WorldInitialize : CCNode
{
	b2World* world_;
}

+(id) setupMarioWithWorld:(b2World*)world;

@end
