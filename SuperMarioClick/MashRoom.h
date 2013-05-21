//
//  MashRoom.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface MashRoom : BodyNode
{
	b2PrismaticJoint* joint;
	bool doPlunge;
	ccTime plungeTime;
    
    b2Body *_plungerBody;
    b2Fixture *_plungerFixture;
}

@property (nonatomic) bool doPlunge;
@property (nonatomic) b2Body* sharedMashRoomBody;
@property (nonatomic) b2Fixture* shareMashRoomFixture;

+(id) mashRoomWithWorld:(b2World*)world;

+(MashRoom*) sharedMashRoom;

-(void)setBody:(b2Body*)body;

-(void)setFixture:(b2Fixture*)fixture;

@end
