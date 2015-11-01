# voronoi_modified_GPUImage
modified GPUImageJFAVoronoiFilter  and GPUImageVoronoiConsumerFilter  for stillImage

0.what is changed from the original GPUImageVoronoi
---------------------------------------------------
i changed the GPUImageJFAVoronoiFilter.h
and GPUImageJFAVoronoiFilter.m
and GPUImageVoronoiConsumerFilter.m
and make Voronoi filter to work with stillImage.(i did not test videoCamera).
because i am a totally newer of opengl-es, i just compare with the implement
of this webgl  exzample which mentioned in  GPUImageJFAVoronoiFilter.h
http://unitzeroone.com/labs/jfavoronoi/,  so please tell me if  something not correct
in my modified codes.

but i change the USAGE when you using the new JFA ,
i move the for circle of numPASSes out from GPUImageJFAVoronoiFilter.m
now GPUImageJFAVoronoiFilter will output a image,then you need to use the original image 
and the image GPUImageJFAVoronoiFilter generated
to pass them (in strict order when addTarget ) to GPUImageVoronoiConsumerFilter

1.how to use it
--------------------
        //first use the 4 files to replace the corresponding files in GPUImage

        GPUImageOutput<GPUImageInput> *filter;
        GPUImagePicture *sourcePicture;
        UIImage * filteredImage;
        CGFloat temp = 0.5;
        GPUImagePicture * stillImage = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lena.jpg"]];
        GPUImageJFAVoronoiFilter * jfa = [[GPUImageJFAVoronoiFilter alloc] init];
        [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
        [jfa setInitStep:temp];
        sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"voronoi_points2.png"]];
        [sourcePicture addTarget:jfa];
        [jfa useNextFrameForImageCapture];
        [sourcePicture processImage];
        [jfa useNextFrameForImageCapture];
        filteredImage = [jfa imageFromCurrentFramebuffer];
        //numPasses = 9
        for (int j=1; j<=9; j++) {
            temp = temp / 2;
            sourcePicture = [[GPUImagePicture alloc] initWithImage:filteredImage];
            [jfa setInitStep:temp];
            [sourcePicture addTarget:jfa];
            [jfa useNextFrameForImageCapture];
            [sourcePicture processImage];
            [jfa useNextFrameForImageCapture];
            filteredImage = [jfa imageFromCurrentFramebuffer];
        }
        filter = [[GPUImageVoronoiConsumerFilter alloc] init];
       [(GPUImageVoronoiConsumerFilter *)filter setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
        sourcePicture = [[GPUImagePicture alloc] initWithImage:filteredImage];
        [stillImage addTarget:filter];
        [sourcePicture addTarget:filter];
        [filter useNextFrameForImageCapture];
        [stillImage processImage];
        [sourcePicture processImage];
        filteredImage = [filter imageFromCurrentFramebuffer];
       [self.selectedImageView setImage:filteredImage];


result_effect
-------------
![image](https://github.com/ihgazni/voronoi_modified_GPUImage/blob/master/lena_stillImage_result.png)
