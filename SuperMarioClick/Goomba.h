//
//  Goomba.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Goomba : BodyNode
{
}

+(id) goombaWithWorld:(b2World*)world position:(CGPoint)pos;

@end