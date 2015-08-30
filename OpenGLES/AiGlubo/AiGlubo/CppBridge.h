//
//  CppBridge.hpp
//  AiGlubo
//
//  Created by Max Bilbow on 29/08/2015.
//  Copyright © 2015 Rattle Media Ltd. All rights reserved.
//

#ifndef CppBridge_hpp
#define CppBridge_hpp

//#include <stdio.h>


#endif /* CppBridge_hpp */

//#import <Foundation/NSObject.h>
//#import <Foundation/NSString.h>
typedef struct _Uniform
{
    float * pm;
    float * mvm;
}Uniform;

@interface CppBridge : NSObject
+ (void) setupScene;
+ (GLKMatrix4) viewMatrix;
+ (GLKVector3) eulerAngles;

+ (GLKMatrix4) projectionMatrix;
+ (Uniform)getUniformWithModelViewMatrix:(GLKMatrix4)modelView withAspect:(float)aspect;
+ (void*)rawProjectionMatrixWithAspect:(float)aspect;

+ (GLKMatrix4) projectionMatrixWithAspect:(float)aspect;
+ (void) updateSceneLogic;

+ (GeometryIterator*)geometries;

+ (void) sendMessage:(NSString* )message;

+ (void) sendMessage:(NSString* )message withScale:(float)scale;

+ (void) moveWithDirection:(NSString* )direction withForce:(float)force;

+ (void) turnAboutAxis:(NSString* )axis withForce:(float)force;

+ (void) sendMessage:(NSString* )message withVector:(GLKVector3)vetor withScale:(float)scale;

+ (NSString*)toStringMatrix4:(GLKMatrix4)m;

+ (const float*)vertsForShape:(unsigned int)shape;
+ (long)sizeOf:(unsigned int)shape;

@end



//extern void RMXSetupScene();
//extern float* RMXModelViewMatrix();
//
//extern void RMXUpdateSceneLogic();
//
//extern void RMXSendMessage(char * message);