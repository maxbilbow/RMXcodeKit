//
//  Node.h
//  RMXKit
//
//  Created by Max Bilbow on 18/08/2015.
//  Copyright © 2015 Rattle Media Ltd. All rights reserved.
//

#ifndef GameNode_hpp
#define GameNode_hpp

#include <stdio.h>
//#import <iostream>
#endif /* Node_h */


namespace rmx {
   
   
    
    class GameNode : public Object { //, public _Node {
   
    protected:
        GameNode * parent = nullptr;
        
    private:
        bool hasBehaviour(Behaviour*);
        static GameNode * _current;
        bool _geometryDidChange;
        long _tick = 0;
        bool _didCollideThisTurn;
        Transform * _transform = nullptr;
        
        bool _hasCamera = FALSE;
        Camera * camera = nullptr;
        
        bool _hasPhysicsBody = FALSE;
        PhysicsBody * _physicsBody = nullptr;
        
        bool _hasGeometry = FALSE;
        Geometry * _geometry = nullptr;
        
//        std::set<GameNode> * c;
        GameNodeList children = GameNodeList();
        
        GameNodeComponents components; //__deprecated_enum_msg("Avoid using until safer key-value mapping implemented") = GameNodeComponents();
        
        GameNodeBehaviours * behaviours = new GameNodeBehaviours();

    protected:
        void onLoad();
        virtual void afterLoad(){}
    public:
        GameNode();
        GameNode(std::string name);
        
        bool didCollideThisTurn();
        void setDidCollideThisTurn(bool);
        GameNode * rootNode();
        long tick();
        CollisionBody * collisionBody();
        void setTransform(Transform * transform);
        
        Transform * getTransform();
        
        static void setCurrent(GameNode * node);
        
        static GameNode * getCurrent();
        
        bool geometryDidChange(bool reset = true);
        
    //    template <class T = NodeComponent>
    private:
        NodeComponent * setComponent(NodeComponent * component) __deprecated_enum_msg("Avoid using until safer key-value mapping implemented");

        NodeComponent * getComponent(std::string className)  __deprecated_enum_msg("Do not use until better keyvalue list implemented");

    public:
        void addBehaviour(Behaviour * behaviour);
       
        

        
//        GameNodeList::Iterator * childNodeIterator();
        
        GameNodeList * getChildren();// __deprecated_enum_msg("Used childNodeIterator instead");
        
        void addChild(GameNode * child);
        bool removeChildNode(GameNode * node);
        
        GameNode * getChildWithName(std::string name);
        
        
        
        
        Camera * getCamera();
        
        bool hasCamera();
        void setCamera(Camera * camera);
        
//        static GameNode * newCameraNode();
        
        
        Geometry * geometry();
        
        
        bool hasGeometry();
        void setGeometry(Geometry * geometry);
        
        PhysicsBody * physicsBody();
        
        bool hasPhysicsBody();
        void setPhysicsBody(PhysicsBody * body);
        
        void updateLogic();
        void updateAfterPhysics();
        
        void draw(Matrix4 rootTransform);
        
        
//        GameNodeList::Iterator * childIterator();
        
        
        GameNode * getParent();
        
//        void setParent(GameNode * parent);
        
        static GameNode * makeCube(float s,PhysicsBody * body = nullptr);//, Behaviour * b);
        
        void addToCurrentScene();

        void SendMessage(std::string message, void * args =   nullptr, SendMessageOptions options = DoesNotRequireReceiver) override;
        void BroadcastMessage(std::string message, void * args =   nullptr, SendMessageOptions options = DoesNotRequireReceiver) override;
        
        static void test();
        virtual std::string ClassName() override {
            return "rmx::GameNode";
        }
    };
    
    

}