//
//  ContackListener.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"
#import "BodyNode.h"
#import "MashRoom.h"
#import "Ball.h"
#import "SuperMarioClick.h"

void ContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	BodyNode* bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode* bodyNodeB = (BodyNode*)bodyB->GetUserData();
	
	// start plunger on contact
	if ([bodyNodeA isKindOfClass:[MashRoom class]] && [bodyNodeB isKindOfClass:[Ball class]])
	{
		MashRoom* mashRoom = (MashRoom*)bodyNodeA;
		//MashRoom.doPlunge = YES;
        [[SuperMarioClick sharedSuperMario] setContactCount:1];
	}
	else if ([bodyNodeB isKindOfClass:[MashRoom class]] && [bodyNodeA isKindOfClass:[Ball class]])
	{
		MashRoom* plunger = (MashRoom*)bodyNodeB;
		//MashRoom.doPlunge = YES;
        [[SuperMarioClick sharedSuperMario] setContactCount:1];
	}
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
}

void ContactListener::EndContact(b2Contact* contact)
{
}

