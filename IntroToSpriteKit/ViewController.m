//
//  ViewController.m
//  IntroToSpriteKit
//
//  Created by Mike Leveton on 4/9/15.
//  Copyright (c) 2015 MEL. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>

static const uint32_t node0Category = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t node1Category = 0x1 << 1;  // 00000000000000000000000000000010
static const uint32_t node2Category = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t node3Category = 0x1 << 3;  // 00000000000000000000000000001000
static const uint32_t node4Category = 0x1 << 4;  // 00000000000000000000000000010000
static const uint32_t node5Category = 0x1 << 5;  // 00000000000000000000000000100000
static const uint32_t sceneCategory = 0x1 << 6;  // 00000000000000000000000000100000
static const uint32_t allCategory = UINT32_MAX;  // 00000000000000000000000000100000


@interface ViewController ()<SKPhysicsContactDelegate>

@property (nonatomic, strong) SKView *spriteKitView;
@property (nonatomic, strong) SKScene *spriteKitScene;
@property (nonatomic, strong) SKSpriteNode *node0;
@property (nonatomic, strong) SKSpriteNode *node1;
@property (nonatomic, strong) SKSpriteNode *node2;
@property (nonatomic, strong) SKSpriteNode *node3;
@property (nonatomic, strong) SKSpriteNode *node4;
@property (nonatomic, strong) SKSpriteNode *node5;

@property (nonatomic, strong) UILabel *label;
@property BOOL isFingerOnNode0;
@property NSInteger counter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"anInteger0: %ld", (long)node0Category);
    NSLog(@"anInteger1: %ld", (long)node1Category);
    NSLog(@"anInteger2: %ld", (long)node2Category);
    NSLog(@"anInteger3: %ld", (long)node3Category);
    NSLog(@"all: %ld", (long)allCategory);
    
    [self setUpLabel];
    
    /* Create the SKView and the SKScene */
    self.spriteKitView = [[SKView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-600)/2, ([UIScreen mainScreen].bounds.size.height-600)/2, 600, 600)];
    [self.spriteKitView.layer setBorderColor:[UIColor blueColor].CGColor];
    [self.spriteKitView.layer setBorderWidth:1.0];
    [self.view addSubview:self.spriteKitView];
    
    self.spriteKitScene = [SKScene sceneWithSize:self.spriteKitView.bounds.size];
    self.spriteKitScene.backgroundColor = [UIColor whiteColor];
    self.spriteKitScene.scaleMode = SKSceneScaleModeAspectFill;
    self.spriteKitScene.name = @"rect";
    
    self.spriteKitScene.physicsWorld.contactDelegate = self;
    self.spriteKitScene.physicsWorld.gravity = CGVectorMake(0,0);
    self.spriteKitScene.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.spriteKitScene.frame];
    self.spriteKitScene.physicsBody.friction = 1.0f;
    self.spriteKitScene.physicsBody.restitution = 0.0f;
    self.spriteKitScene.physicsBody.categoryBitMask = sceneCategory;

    
    /* Present the SKScene from the SKView */
    
    [self.spriteKitView presentScene:self.spriteKitScene];
    
    NSInteger maxWidth = self.spriteKitView.bounds.size.width;
    NSInteger maxHeight = self.spriteKitView.bounds.size.height;
    
    /* create one node for user interaction */
    
    self.node0 = [SKSpriteNode spriteNodeWithImageNamed:@"rageComic1"];
    CGFloat diameter = 40;
    self.node0.name = @"zero";
    self.node0.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:diameter/2];
    self.node0.physicsBody.allowsRotation = NO;
    self.node0.physicsBody.restitution = 0.0f;
    self.node0.physicsBody.linearDamping = 0.0f;
    self.node0.physicsBody.friction = 0.0f;
    self.node0.physicsBody.collisionBitMask = sceneCategory;
    self.node0.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node0.physicsBody.categoryBitMask = node0Category;
    self.node0.physicsBody.contactTestBitMask = node1Category | node2Category | node3Category | node4Category | node5Category;
    [self.spriteKitScene addChild:self.node0];
    
    
    /* create 5 other nodes, you can usea loop here instead of hardcoding, but I didn't for teaching puposes */
    
    self.node1 = [self createSpriteNodeWithName:@"one"];
    self.node1.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node1.physicsBody.categoryBitMask = node1Category;
    self.node1.physicsBody.contactTestBitMask = node0Category | node2Category | node3Category | node4Category | node5Category;
    [self.spriteKitScene addChild:self.node1];
    [self.node1.physicsBody applyImpulse:CGVectorMake(-10.0f, 10.0f)];
    
    self.node2 = [self createSpriteNodeWithName:@"one"];
    self.node2.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node2.physicsBody.categoryBitMask = node2Category;
    self.node2.physicsBody.contactTestBitMask = node0Category | node1Category | node3Category | node4Category | node5Category;
    [self.spriteKitScene addChild:self.node2];
    [self.node2.physicsBody applyImpulse:CGVectorMake(-10.0f, 0.0f)];
    
    self.node3 = [self createSpriteNodeWithName:@"three"];
    self.node3.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node3.physicsBody.categoryBitMask = node3Category;
    self.node3.physicsBody.contactTestBitMask = node0Category | node1Category | node2Category | node4Category | node5Category;
    [self.spriteKitScene addChild:self.node3];
    [self.node3.physicsBody applyImpulse:CGVectorMake(0.0f, -10.0f)];
    
    self.node4 = [self createSpriteNodeWithName:@"four"];
    self.node4.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node4.physicsBody.categoryBitMask = node4Category;
    self.node4.physicsBody.contactTestBitMask = node0Category | node1Category | node2Category | node3Category | node5Category;
    [self.spriteKitScene addChild:self.node4];
    [self.node4.physicsBody applyImpulse:CGVectorMake(0.0f, 10.0f)];
    
    self.node5 = [self createSpriteNodeWithName:@"five"];
    self.node5.position = CGPointMake(arc4random() % maxWidth, arc4random() % maxHeight);
    self.node5.physicsBody.categoryBitMask = node5Category;
    self.node5.physicsBody.contactTestBitMask = node0Category | node1Category | node2Category | node3Category | node4Category;
    [self.spriteKitScene addChild:self.node5];
    [self.node5.physicsBody applyImpulse:CGVectorMake(10.0f, 10.0f)];
    
}

/* convenience method to give the same properties to the other 4 nodes */
- (SKSpriteNode *)createSpriteNodeWithName:(NSString *)name
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"rageComic0"];
    CGFloat diameter = 40;
    node.name = name;
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:diameter/2];
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0.0f;
    node.physicsBody.friction = 0.0f;

    
    return node;
}

#pragma mark - SKPhysicsContactDelegate

/* gets called when 2 nodes collide and 1 node's categoryBitmask is the same as the other nodes contactTestBitmask */
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (self.isFingerOnNode0)
    {
        /* use the bitmask to determine which physics body is node0 since this method doesn't provide an order */
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if ((firstBody.categoryBitMask == node0Category && secondBody.categoryBitMask != sceneCategory) || (secondBody.categoryBitMask == node0Category && firstBody.categoryBitMask != sceneCategory))
        {
            [secondBody.node removeFromParent];
            self.counter++;
        }
        
        if (self.counter >= 5)
        {
            [self.label setText:@"GAME WON"];
            return;
        }
    }
    
    if (![contact.bodyA.node.name isEqualToString:@"rect"])
    {
        [self.label setText:[NSString stringWithFormat:@"%@ collided with %@", contact.bodyA.node.name, contact.bodyB.node.name]];
    }
    
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    
}


/* handle user interaction */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.spriteKitScene];
    
    SKPhysicsBody *body = [self.spriteKitScene.physicsWorld bodyAtPoint:touchLocation];
    
    if (body && [body.node.name isEqualToString:@"zero"])
    {
        self.isFingerOnNode0 = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isFingerOnNode0)
    {
        /* 2 Get touch location */
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self.spriteKitScene];
        CGPoint previousLocation = [touch previousLocationInNode:self.spriteKitScene];
        
        /* 3 Get node0 */
        SKSpriteNode *node = (SKSpriteNode *)[self.spriteKitScene childNodeWithName:@"zero"];
        
        /* 4 Take the current position and add the diff b/t the new and previous positions */
        NSInteger nodeXposition = node.position.x + (touchLocation.x - previousLocation.x);
        
        /* 5 Limit x so that node0 will not leave the screen to left or right */
        nodeXposition = MAX(nodeXposition, node.size.width/2);
        nodeXposition = MIN(nodeXposition, self.spriteKitScene.size.width - node.size.width/2);
        
        /* 6 Limit x so that node0 will not leave the screen to the top or bottom */
        NSInteger nodeYposition = node.position.y + (touchLocation.y - previousLocation.y);
        nodeYposition = MAX(nodeYposition, node.size.height/2);
        nodeYposition = MIN(nodeYposition, self.spriteKitScene.size.height - node.size.height/2);

        node.position = CGPointMake(nodeXposition, nodeYposition);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.counter = 0;
    self.isFingerOnNode0 = NO;
}



- (void)setUpLabel
{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-600)/2, 0, 600, 100)];
    [self.label setText:NSLocalizedString(@"info", nil)];
    [self.label setNumberOfLines:0];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
    [self.label setTextColor:[UIColor redColor]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.label setMinimumScaleFactor:0.75];
    [self.label setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.label];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
}

@end
