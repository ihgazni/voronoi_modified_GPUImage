#import "GPUImageTwoInputFilter.h"

//#import "GPUImageTwoPassFilter.h"

//GPUImageTwoInputFilter

@interface GPUImageVoronoiConsumerFilter : GPUImageTwoInputFilter
{
    GLint sizeUniform;
}

@property (nonatomic, readwrite) CGSize sizeInPixels;

@end
