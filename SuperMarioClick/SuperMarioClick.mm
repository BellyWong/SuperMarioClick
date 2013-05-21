//
//  SuperMarioClick.mm
//  SuperMarioClick
//
//  Created by liu weimu on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SuperMarioClick.h"
#import "cocos2d.h"
#import "Box2D.h"
#import <Foundation/Foundation.h>
#import "SuperMarioClick.h"
#import "Ball.h"
#import "Constants.h"
#import "Helper.h"
#import "WorldInitialize.h"
#import "MashRoom.h"

@interface SuperMarioClick (PrivateMethods)
-(void) initBox2dWorld;
-(void) enableBox2dDebugDrawing;
@end


@implementation SuperMarioClick

static SuperMarioClick* superMarioInstance;

// Show score
CCLabelTTF* label ;

// Fighting
CCLabelTTF* fighting;

// You are the man
CCLabelTTF* man;

// Instance of Mashroom
MashRoom* mashRoom;

b2Body* containerBody;


+(SuperMarioClick*) sharedSuperMario
{
	//NSAssert(pinballTableInstance != nil, @"table not yet initialized!");
	return superMarioInstance;
}

+(id) scene
{
	CCScene* scene = [CCScene node];
	SuperMarioClick* layer = [SuperMarioClick node];
	[scene addChild:layer];
	return scene;
}


-(id) init
{
	if ((self = [super init]))
	{
		superMarioInstance = self;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
		[self initBox2dWorld];
		[self enableBox2dDebugDrawing];
		
		// Preload the sprite frames from the texture atlas
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"manofclick.plist"];
        
		// batch node for all dynamic elements
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"manofclick.png" capacity:100];
		[self addChild:batch z:-2 tag:kTagBatchNode];
		
        // Background
        CCSprite* background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(220,240)];
 		[self addChild:background z:-3];
        
        // Move the background
		CCMoveBy* move1 = [CCMoveBy actionWithDuration:5 position:CGPointMake(-220, 0)];
		CCMoveBy* move2 = [CCMoveBy actionWithDuration:5 position:CGPointMake(220, 0)];
		CCSequence* sequence = [CCSequence actions:move1, move2, nil];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
		[background runAction:repeat];
        
		// Setup static elements
        WorldInitialize* setUp = [WorldInitialize setupMarioWithWorld:world];
        [self addChild:setUp z:-1];
        
        // Add the scorebord
        label = [CCLabelTTF labelWithString:@"0" fontName:@"Arial-BoldMT" fontSize:26];
		[self addChild:label];
		[label setColor:ccc3(255, 0, 0)];
		[label setPosition:ccp(70,450)];
        
        // Add the scorebord
        fighting = [CCLabelTTF labelWithString:@"その調子だ！！" fontName:@"Arial-BoldMT" fontSize:26];
		[self addChild:fighting];
		[fighting setColor:ccc3(0, 255, 0)];
		[fighting setPosition:ccp(160,500)];
        //fighting.opacity = 255;
        
        // Add the scorebord
        man = [CCLabelTTF labelWithString:@"すごい！君に負けた" fontName:@"Arial-BoldMT" fontSize:30];
		[self addChild:man];
		[man setColor:ccc3(0, 255, 0)];
		[man setPosition:ccp(160,500)];
        //man.opacity = 255;
        
        // Get the body and fixture to move the mushroom
        _paddleFixture = [[MashRoom sharedMashRoom]shareMashRoomFixture];
        _paddleBody = [[MashRoom sharedMashRoom]sharedMashRoomBody];
        
        self.isTouchEnabled = YES;
        
        // Menu
        [self createMenu];
        
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete contactListener;
	contactListener = NULL;
	
	delete debugDraw;
	debugDraw = NULL;
    
	superMarioInstance = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) initBox2dWorld
{
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, -5.0f);
	bool allowBodiesToSleep = true;
    world = new b2World(gravity);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
	int density = 0;
    
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    containerBody = world->CreateBody(&groundBodyDef);
    
    b2EdgeShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    
    groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    _bottomFixture = containerBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    containerBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 
                                                              winSize.height/PTM_RATIO));
    containerBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), 
                  b2Vec2(winSize.width/PTM_RATIO, 0));
    containerBody->CreateFixture(&groundBoxDef);
    
}

-(void) enableBox2dDebugDrawing
{
}

-(CCSpriteBatchNode*) getSpriteBatch
{
	return (CCSpriteBatchNode*)[self getChildByTag:kTagBatchNode];
}

-(void) update:(ccTime)delta
{
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		BodyNode* bodyNode = (BodyNode*)body->GetUserData();
		if (bodyNode != NULL && bodyNode.sprite != nil)
		{
			// update the sprite's position to where their physics bodies are
			bodyNode.sprite.position = [Helper toPixels:body->GetPosition()];
			float angle = body->GetAngle();
			bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));
            
            // update the scoreboard if the ball fall on the floor
            if([BodyNode isKindOfClass:[Ball class]])
            {
                if(bodyNode.sprite.position.x < 20)
                {
                    contackCount = 0;
                }
            }
		}
	}
    [label setString: [NSString stringWithFormat:@"%@ %d",@"TOTAL: ",contackCount]];    
}

// set contackCount
-(void)setContactCount:(int)count
{
    if (count == 0)
    {
        contackCount = 0;
    }
    else
    {
        contackCount += 1;
        [self splashScreen];
    }
}

-(void) createMenu
{ 
    CCMenuItemImage* resetimg = [CCMenuItemImage itemFromNormalImage:@"Reset.png" selectedImage:@"Reset.png" target:self selector:@selector(resetGame:)];
    
	CCMenu *menu = [CCMenu menuWithItems:resetimg, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width -36, size.height -36)];
	
	
	[self addChild: menu z:-1];	
}

-(void)resetGame:(id)sender{
    //[[CCDirector sharedDirector] replaceScene: [PinballTable scene]];
    [[Ball sharedBall]gameReset];
}

-(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (_paddleFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = containerBody;
        md.bodyB = _paddleBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * _paddleBody->GetMass();
        
        _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
        _paddleBody->SetAwake(true);
    }
    
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

-(void)splashScreen{
    
    CCMoveTo* splashmove = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(160, 360)];
    CCBlink* splashblink = [CCBlink actionWithDuration:2 blinks:4];
    CCBlink* manblink = [CCBlink actionWithDuration:3 blinks:3];
    CCMoveTo* splashmoveBack = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(160,500)];
    CCSequence* splashsequence = [CCSequence actions:splashmove,splashblink,splashmoveBack, nil];
    CCSequence* mansequence = [CCSequence actions:splashmove,manblink,splashmoveBack, nil];
    if(contackCount!= 0 && contackCount % 10 == 0 && contackCount!= 100){
        
        [fighting runAction:splashsequence];
    }
    if(contackCount == 100)
    {
        [man runAction:mansequence];
    }
}


#ifdef DEBUG
-(void) draw
{
}
#endif



@end
