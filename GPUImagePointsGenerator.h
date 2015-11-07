//
//  GPUImagePointsGenerator.h
//  PhotoFX
//
//  Created by dli on 11/3/15.
//  Copyright (c) 2015 Mobiletuts. All rights reserved.
//

#ifndef PhotoFX_GPUImagePointsGenerator_h
#define PhotoFX_GPUImagePointsGenerator_h


#endif

#import <GPUImage.h>
#import "GPUImageFilter.h"

@interface GPUImagePointsGenerator : GPUImageFilter
{
    //GLfloat red;
    //GLfloat green;
    //GLfloat blue;
}

- (float)genRandomFloat:(int)upperLimit;

@property(readwrite, nonatomic) int pointsCount;
@property (nonatomic, readwrite) BOOL useSelfDefinedSize;
@property (nonatomic, readwrite) CGSize sizeInPixels;


@end


