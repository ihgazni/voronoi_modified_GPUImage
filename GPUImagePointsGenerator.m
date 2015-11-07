//
//  GPUImagePointsGenerator.m
//  PhotoFX
//
//  Created by dli on 11/3/15.
//  Copyright (c) 2015 Mobiletuts. All rights reserved.
//


#import "GPUImagePointsGenerator.h"

@implementation GPUImagePointsGenerator

@synthesize pointsCount = _pointsCount;
@synthesize useSelfDefinedSize = _useSelfDefinedSize;
@synthesize sizeInPixels = _sizeInPixels;

NSString *const kGPUImagePointsGeneratorVertexShaderString = SHADER_STRING
(
 
 attribute vec4 position;
 varying float r;
 varying float g;
 varying float b;
 
 
 void main()
 {
     gl_Position = position;
     if ( (position.x < 0.5) && (position.y < 0.5) ) {
         r = position.x;
         g = 0.5 - position.y;
         b = 2.0 / 255.0;
     }
     if ( (position.x < 0.5) && (position.y > 0.5) ) {
         r = position.x;
         g = 1.0 - position.y;
         b = 0.0 ;
     }
     if ( (position.x > 0.5) && (position.y < 0.5) ) {
         r = position.x - 0.5;
         g = 0.5 - position.y;
         b = 3.0 / 255.0;
     }
     if ( (position.x > 0.5) && (position.y > 0.5) ) {
         r = position.x - 0.5 ;
         g = 1.0 - position.y;
         b = 1.0 / 255.0;
     }
 }
 
 );


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImagePointsGeneratorFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying float r;
 varying float g;
 varying float b;

 
 void main()
 {
     gl_FragColor = vec4(r,g,b,1.0);
 }
);
#else
NSString *const kGPUImagePointsGeneratorFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying float r;
 varying float g;
 varying float b;

 
 void main()
 {
     gl_FragColor = vec4(r,g,b,1.0);
 }
 );
#endif

#pragma mark -
#pragma mark Initialization and teardown



- (id)init;
{
    if (!(self = [super initWithVertexShaderFromString:kGPUImagePointsGeneratorVertexShaderString fragmentShaderFromString:kGPUImagePointsGeneratorFragmentShaderString]))
    {
        return nil;
    }
    
    self.pointsCount = 3000;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setPointsCount:(int)newValue;
{
    _pointsCount = newValue;
    
}

- (float)genRandomFloat:(int)upperLimit;
{
    int r = arc4random_uniform(upperLimit);

    float y = (float)r / (float)upperLimit;

    if (y > 0.99999) {
        y = 1.0;
    }
    r = arc4random_uniform(2);
    if (r==0) {
    } else {
        y = -y;
    }
    return(y);
}


-(void)setSizeInPixels:(CGSize)sizeInPixels {
    _sizeInPixels = sizeInPixels;
    
    //validate that it's a power of 2 and square
    
    float width = log2(sizeInPixels.width);
    float height = log2(sizeInPixels.height);
    
    if (width != height) {
        NSLog(@"Voronoi point texture must be square");
        return;
    }
    if (width != floor(width) || height != floor(height)) {
        NSLog(@"Voronoi point texture must be a power of 2.  Texture size %f, %f", sizeInPixels.width, sizeInPixels.height);
        return;
    }
    
    _sizeInPixels.width = pow(2,width);
    _sizeInPixels.height = pow(2,height);
    
}


-(void)setUseSelfDefinedSize:(BOOL)useSelfDefinedSize {
    _useSelfDefinedSize = useSelfDefinedSize;
        
}



- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    GLfloat realVertices[_pointsCount];
    
    for (int i = 0; i < _pointsCount; i++) {
        float x = [self genRandomFloat:999999];
        realVertices[i] = x;
    }
    

    
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    
    
    if (_useSelfDefinedSize == YES) {
        
        outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:_sizeInPixels textureOptions:self.outputTextureOptions onlyTexture:NO];
        
        
    } else {
    
        outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    
    }
    
    
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    [self setUniformsForProgramAtIndex:0];
    
    

    
    glClearColor(0.0,0.0,0.0,0.0);
    //glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);

    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, &realVertices);
    
    NSLog(@"points counts : %d", _pointsCount);
    
    glDrawArrays(GL_POINTS, 0, _pointsCount);
    
    
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }

    
    
    
}


@end
