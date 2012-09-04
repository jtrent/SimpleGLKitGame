//
//  SGGSprite.h
//  SimpleGLKitGame
//
//  Created by Jon Trent on 9/1/12.
//  Copyright (c) 2012 Senator Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SGGSprite : NSObject

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;
- (void)render;

@end
