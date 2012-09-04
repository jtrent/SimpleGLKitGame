//
//  SGGViewController.m
//  SimpleGLKitGame
//
//  Created by Jon Trent on 8/31/12.
//  Copyright (c) 2012 Senator Studios. All rights reserved.
//

#import "SGGViewController.h"
#import "SGGSprite.h"

@interface SGGViewController()
@property (strong, nonatomic) EAGLContext *context;
@property (strong) GLKBaseEffect *effect;
@property (strong) SGGSprite *player;
@property (strong) NSMutableArray *children;
@end

@implementation SGGViewController
@synthesize context = _context;
@synthesize player = _player;
@synthesize children = _children;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 480, 0, 320, -1024, 1024);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    self.player = [[SGGSprite alloc] initWithFile:@"Player.png" effect:self.effect];
    self.player.position = GLKVector2Make((self.player.contentSize.width / 2), 160);
    
    self.children = [NSMutableArray array];
    [self.children addObject:self.player];
    //self.player.moveVelocity = GLKVector2Make(50, 50);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    for (SGGSprite *sprite in self.children) {
        [sprite render];
    }
}

- (void)update {
    for (SGGSprite *sprite in self.children) {
        [sprite update:self.timeSinceLastUpdate];
    }
}



@end
