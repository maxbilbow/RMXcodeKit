//
//  CppBridge.cpp
//  AiGlubo
//
//  Created by Max Bilbow on 29/08/2015.
//  Copyright © 2015 Rattle Media Ltd. All rights reserved.
//
#import "RMXEngine.hpp"
#import "AiCubo.hpp"
//#import <GLKit/GLKMatrix4.h>
#include "VertexData.h"
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#include "GeometryIterator.h"
#include "CppBridge.h"
#include <thread>

using namespace rmx;
using namespace std;

AiCubo game = AiCubo();

@implementation CppBridge

static GeometryIterator * geometries;
static CppButtons * buttons;
+ (void) setupScene
{
//    RMXLoadVertices();
    game.run();
    geometries = [GeometryIterator new];
}

+ (CppButtons*)buttons
{
    return buttons;
}

+ (GeometryIterator*)geometries
{
    return geometries;
}
+ (GLKMatrix4) projectionMatrix
{
    return Scene::getCurrent()->pointOfView()->getCamera()->projectionMatrix();
}


+ (Uniform)getUniformWithModelViewMatrix:(GLKMatrix4)modelView withAspect:(float)aspect {
    Uniform u;
    u.pm = [CppBridge projectionMatrixWithAspect:aspect].m;
    u.mvm = modelView.m;
    return u;
}


+ (float*)rawProjectionMatrixWithAspect:(float)aspect
{
    
    GLKMatrix4 m =[CppBridge projectionMatrixWithAspect:aspect];
    float * M = m.m;
    return M;
}

+ (GLKMatrix4) projectionMatrixWithAspect:(float)aspect {
    return Scene::getCurrent()->pointOfView()->getCamera()->projectionMatrix(aspect);
}

+ (GLKVector3)eulerAngles
{
    return Scene::getCurrent()->pointOfView()->getTransform()->eulerAngles();
}

+ (GLKMatrix4) viewMatrix
{
    return Scene::getCurrent()->pointOfView()->getCamera()->viewMatrix();
}


void update(GameController * gc) {
    gc->updateBeforeScene(nullptr);
    Scene::getCurrent()->updateSceneLogic();
    gc->updateAfterScene(nullptr);
}

thread sceneThread;

+ (void) updateSceneLogic{
    if (sceneThread.joinable()) {
        sceneThread.join();
    }
    GameController * gc = GameController::getInstance();
    sceneThread = thread(update,gc);
//    Scene::getCurrent()->renderScene(moodelMatrix);
}


+ (void) moveWithDirection:(NSString* )direction withForce:(float)force
{
    GameNode * player = GameNode::getCurrent();
    GameNode * camera = Scene::getCurrent()->pointOfView();
    if ([direction isEqualToString:@"forward"])
        player->physicsBody()->applyForce(Forward, force);
    else if ([direction isEqualToString:@"left"])
        player->physicsBody()->applyForce(Left, force);
    else if ([direction isEqualToString:@"up"])
        player->physicsBody()->applyForce(Up, force);
    else if ([direction isEqualToString:@"pitch"])
        camera->physicsBody()->applyTorque(Pitch, force);
    else if ([direction isEqualToString:@"yaw"])
        player->physicsBody()->applyTorque(Yaw, force);
    else if ([direction isEqualToString:@"roll"])
        player->physicsBody()->applyTorque(Roll, force);

//     cout << player->getTransform()->position() << endl;
}

+ (void) turnAboutAxis:(NSString* )axis withForce:(float)force
{
    GameNode * player = GameNode::getCurrent();
    GameNode * camera = Scene::getCurrent()->pointOfView();
    if ([axis isEqualToString:@"pitch"])
        camera->getTransform()->rotate(Pitch, force);
    else if ([axis isEqualToString:@"yaw"])
        player->physicsBody()->applyTorque(Yaw, force);
    else if ([axis isEqualToString:@"roll"])
        player->physicsBody()->applyTorque(Roll, force);
}

+ (void) sendMessage:(NSString*)message {
//    NSLog(@"Unimplemented message received: %@",message);
    GameNode * player = GameNode::getCurrent();
    player->BroadcastMessage([message UTF8String]);
}

+ (void) sendMessage:(NSString* )message withBool:(bool)on
{
    GameNode * player = GameNode::getCurrent();
    player->BroadcastMessage([message UTF8String],&on);
}

+ (void) sendMessage:(NSString* )message withScale:(float)scale {
    GameNode * player = GameNode::getCurrent();//->pointOfView();
    if ([message isEqualToString:@"jump"]) {
        if (scale == 0)
            player->BroadcastMessage("crouch");
        else if (scale == 1)
            player->BroadcastMessage("jump");
    } else {
        player->BroadcastMessage([message UTF8String],&scale);
//        NSLog(@"Unimplemented Massage received: %@:@%f",message,scale);
    }
}

+ (void)setKey:(int)key action:(int)action withMods:(int)mods
{
    GameController::keyCallback(nullptr, key, 0, action, mods);
}


+ (void)setCursor:(double)x y:(double)y
{
    GameController::cursorCallback(nullptr, x, y);
}

+ (void)cursorDelta:(double)dx dy:(double)dy
{
    GameController::cursorCallback(nullptr, dx, dy);
}

+ (void) sendMessage:(NSString* )message withVector:(GLKVector3)vector withScale:(float)scale {
    NSLog(@"Unimplemented Massage received: %@:%f:(%f,%f,%f)",message,scale,vector.x,vector.y,vector.z);
}
    + (NSString*)toStringMatrix4:(GLKMatrix4)m
    {
        NSString * s = @"AFTER Matrix:\n";
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%f, %f, %f, %f\n", m.m00, m.m01, m.m02, m.m03]];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%f, %f, %f, %f\n", m.m10, m.m11, m.m12, m.m13]];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%f, %f, %f, %f\n", m.m20, m.m21, m.m22, m.m23]];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%f, %f, %f, %f\n", m.m30, m.m31, m.m32, m.m33]];
        
        return s;

    }
    
@end


@implementation CppButtons {
@private Buttons * buttons;
}


- (id)init
{
    self = [super init];
    return self;
}

- (void)forwards:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::forwards:(float)percentage");
}

- (void)backwards:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::backwards:(float)percentage");
}

- (void)left:(float)percentage
{
     rmx::log("Not yet implemented", "Buttons::left:(float)percentage");
}

- (void)right:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::right:(float)percentage");
}

- (void)up:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::up:(float)percentage");
}

- (void)down:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::down:(float)percentage");
}

- (void)crouch:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::crouch:(float)percentage");
}

- (void)jump:(float)percentage
{
    rmx::log("Not yet implemented", "Buttons::jump:(float)percentage");
}

@end