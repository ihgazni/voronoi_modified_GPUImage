//
//  GPUImageRemap_1.m
//  PhotoFX
//
//  Created by dli on 10/24/15.
//  Copyright (c) 2015 Mobiletuts. All rights reserved.
//

#import "GPUImageRemap_1.h"



NSString *const kGPUImageRemap_1ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;

 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texel.r;
     mapped.g = texel.g;
     mapped.b = texel.b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );

@implementation GPUImageRemap_1

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageRemap_1ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
