//
//  ContackListener.h
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"

class ContactListener : public b2ContactListener
{
private:
	void BeginContact(b2Contact* contact);
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	void EndContact(b2Contact* contact);
};
