#import "GPUImageVoronoiConsumerFilter.h"


NSString *const kGPUImageVoronoiConsumerVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 attribute vec4 inputTextureCoordinate2;
 
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 void main()
 {
     textureCoordinate = inputTextureCoordinate.xy;
     textureCoordinate2 = inputTextureCoordinate2.xy;
     gl_Position = vec4(position.x , position.y , 0.0, 1.0);
 }

 );




#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageVoronoiConsumerFragmentShaderString = SHADER_STRING
(
 
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform vec2 size;
 varying vec2 textureCoordinate;
 
 vec2 getCoordFromColor(vec4 color)
{
    float z = color.z * 256.0;
    float yoff = floor(z / 8.0);
    float xoff = mod(z, 8.0);
    float x = color.x*256.0 + xoff*256.0;
    float y = color.y*256.0 + yoff*256.0;
    return vec2(x,y) / size;
}
 
 void main(void) {
     vec4 colorLoc = texture2D(inputImageTexture2, textureCoordinate);
     vec4 color = texture2D(inputImageTexture, getCoordFromColor(colorLoc));
     
     gl_FragColor = color;
 }
 );
#else
NSString *const kGPUImageVoronoiConsumerFragmentShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform vec2 size;
 varying vec2 textureCoordinate;
 
 vec2 getCoordFromColor(vec4 color)
 {
     float z = color.z * 256.0;
     float yoff = floor(z / 8.0);
     float xoff = mod(z, 8.0);
     float x = color.x*256.0 + xoff*256.0;
     float y = color.y*256.0 + yoff*256.0;
     return vec2(x,y) / size;
 }
 
 void main(void)
 {
     vec4 colorLoc = texture2D(inputImageTexture2, textureCoordinate);
     vec4 color = texture2D(inputImageTexture, getCoordFromColor(colorLoc));
     
     gl_FragColor = color;
 }
 );
#endif

@implementation GPUImageVoronoiConsumerFilter

@synthesize sizeInPixels = _sizeInPixels;
////当@synthesize被省略的时候@synthesize var=_var是LLVM 4.0自动生成的你可以把它当做Objective-C的默认命名规则
////通过@property 声明了属性之后 在类的实现文件中 可以不写@synthesize  系统会自动生成
////@synthesize toDoItems = _toDoItems；
////你如果想通过getter方法来访问属性 需要写成self.toDoItems ,_toDoItems 是直接访问变量

- (id)init;
{
    //initWithFragmentShaderFromString:kGPUImageVoronoiConsumerFragmentShaderString
    
    if (!(self = [super initWithVertexShaderFromString:kGPUImageVoronoiConsumerVertexShaderString fragmentShaderFromString:kGPUImageVoronoiConsumerFragmentShaderString]))
    {
        return nil;
    }
    
    sizeUniform = [filterProgram uniformIndex:@"size"];
    
    return self;
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
    glUniform2f(sizeUniform, _sizeInPixels.width, _sizeInPixels.height);
}

@end
