//
//  SGGSprite.m
//  SimpleGLKitGame
//
//  Created by Senator on 9/1/12.
//  Copyright (c) 2012 Senator. All rights reserved.
//

#import "SGGSprite.h"

typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
} TexturedQuad;

TexturedQuad TexturedQuadMake(CGFloat width, CGFloat height);

@interface SGGSprite()

@property (strong) GLKBaseEffect *effect;
@property (assign) TexturedQuad quad;
@property (strong) GLKTextureInfo *textureInfo;

@end

@implementation SGGSprite
@synthesize effect = _effect;
@synthesize quad = _quad;
@synthesize textureInfo = _textureInfo;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        self.effect = effect;
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 GLKTextureLoaderOriginBottomLeft,
                                 nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        
        if (self.textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        
        self.quad = TexturedQuadMake(self.textureInfo.width, self.textureInfo.height);
    }
    
    return self;
}

- (void)render {
    self.effect.texture2d0.name = self.textureInfo.name;
    self.effect.texture2d0.enabled = YES;
    
    [self.effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    long offset = (long)&_quad;
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offset + offsetof(TexturedVertex, textureVertex)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

TexturedQuad TexturedQuadMake(CGFloat width, CGFloat height) {
    TexturedQuad newQuad;
    newQuad.bl.geometryVertex = CGPointMake(0, 0);
    newQuad.br.geometryVertex = CGPointMake(width, 0);
    newQuad.tl.geometryVertex = CGPointMake(0, height);
    newQuad.tr.geometryVertex = CGPointMake(width, height);
    newQuad.bl.textureVertex = CGPointMake(0, 0);
    newQuad.br.textureVertex = CGPointMake(1, 0);
    newQuad.tl.textureVertex = CGPointMake(0, 1);
    newQuad.tr.textureVertex = CGPointMake(1, 1);
    
    return newQuad;
}

@end
