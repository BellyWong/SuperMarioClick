//
//  SuperMarioClick.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"

enum
{
	kTagBatchNode,
};

@interface SuperMarioClick : CCLayer
{
    b2World* world;
	ContactListener* contactListener;
	
    // mouse move joint
    b2MouseJoint *_mouseJoint;
    
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
    
	GLESDebugDraw* debugDraw;
    
    // contack cound
    int contackCount;
}

+(SuperMarioClick*) sharedSuperMario;

+(id) scene;

-(CCSpriteBatchNode*) getSpriteBatch;

@end
