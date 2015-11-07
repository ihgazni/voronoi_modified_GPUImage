//
//  GPUImageRemap_2.m
//  PhotoFX
//
//  Created by dli on 10/24/15.
//  Copyright (c) 2015 Mobiletuts. All rights reserved.
//

#import "GPUImageRemap_2.h"


NSString *const kGPUImageRemap_2ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);

     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture2, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture2, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture2, vec2(texel.b, .83333)).b;
     
     
     
     
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );


@implementation GPUImageRemap_2

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageRemap_2ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end



