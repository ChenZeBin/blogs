# OpenGL

## 硬件介绍
- GPU主要是负责绘制，CPU也可以绘制，但是效率没有GPU高

> 这样理解他们的区别：GPU有很多小处理单元，CPU只有几个大处理单元，比如4核CPU就4个大处理单元。GPU的小处理单元复杂度比CPU低，所以流程控制不能替代CPU，就像一堆小学生可以很快的同时解决一堆加减乘除习题，不能解决高数问题

- 显卡的主要组成硬件就是CPU

- 显卡驱动：显卡驱动是OpenGL的内核层（也就是OpenGL的具体实现），上层就是OpenGL接口层了

![](https://raw.githubusercontent.com/ChenZeBin/MyPicture/master/pic/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%E5%88%B0%E7%A1%AC%E4%BB%B6%E6%9E%B6%E6%9E%84%E5%9B%BE.png)


## OpenGL是什么？
OpenGL是指一个接口规范，比如操作iOS系统，apple提供了很多接口；那么我们要操作GPU这个硬件，也有一套接口，就是OpenGL；之所以定义这个规范，是因为生产显卡的厂家不一样，如果大家提供的接口不一样，那么上层开发者就比较麻烦，所以Khronos组织制定并维护了这个规范；具体的实现，比如OpenGL有一个A接口是画一个圆，那么具体的实现就GPU厂家各自去实现。

所以OpenGL库有很多，一般都是由显卡商去开发维护的

## OpenGL简介


在屏幕上画出一个三角形的数据流向：

- 某个线程上调用OpenGL画三角形的接口


在OpenGL中，任何事物都在3D空间中，而屏幕和窗口却是2D像素数组，这导致OpenGL的大部分工作都是关于把3D坐标转变为适应你屏幕的2D像素

CPU、GPU、显示卡驱动程序、OpenGL、硬件加速

## OpenGL、metal、Direct X、Vulkan


## 关于iOS平台上的OpenGL ES
主要翻译[OpenGL ES Programming Guide](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Introduction/Introduction.html)
> OpenGL ES在iOS12中被弃用，可以使用Metal替代

OpenGL ES是OpenGL的简化版，阉割了多余的功能，是一个在移动图形硬件中更容易学习和实现的库。

![](https://github.com/ChenZeBin/MyPicture/blob/master/pic/OpenGLES.png?raw=true)

OpenGL ES能够控制底层图形处理器（GPU）的能力；iOS设备上的GPU硬件可以执行复杂的2D、3D绘图，以及对最终图像中的每个像素进行复杂的阴影计算。如果你需要对GPU硬件进行最直接，最全面的访问，那么你应该使用OpenGL ES。比较典型的应用场景就是3D游戏和绘制3D图形。

OpenGL ES是低级，面向硬件的API（言外之意就是没那么人性化，比高级语言的api难用），虽然它提供最强大最灵活的图形处理能力，但是他的学习曲线比较陡峭

iOS也提供了一些高层次的框架，高性能的处理图形绘制：

- SpriteKit提供了一个为创建2D游戏而优化的硬件加速动画系统[(See SpriteKit Programming Guide.)](https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013043)
> 这里硬件加速指的就是使用GPU去绘制，软件加速指的就是CPU绘制

- Core Image处理图片和视频滤镜[(See Core Image Programming Guide.)](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html#//apple_ref/doc/uid/TP30001185)

- Core Animation提供硬件加速的图形渲染和动画，也是一个简单的声明式API，使得实现复杂的动画变得简单[(See Core Animation Programming Guide.)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514)

- UIKit

### OpenGL ES在iOS中的实现是与平台无关的
因为OpenGL ES是基于C的API，所以他具有很强的移植性和广泛的平台支持。他能够与OC项目无缝集成。

OpenGL规范中没有定义窗口的接口，因为这些在每个系统上都不一样，所以对应的实现库都得自己创造并实现OpenGL的上下文，窗口，以及处理用户的输入

> 引用[LearnOpenGL CN](https://learnopengl-cn.github.io/01%20Getting%20started/02%20Creating%20a%20window/)
> 
> 在我们画出出色的效果之前，首先要做的就是创建一个OpenGL上下文(Context)和一个用于显示的窗口。然而，这些操作在每个系统上都是不一样的，OpenGL有目的地从这些操作抽象(Abstract)出去。这意味着我们不得不自己处理创建窗口，定义OpenGL上下文以及处理用户输入。

所以进行OpenGL应用开发，第一件事就是创建窗口

> Relevant Chapters: [Checklist for Building OpenGL ES Apps for iOS](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/OpenGLESontheiPhone/OpenGLESontheiPhone.html#//apple_ref/doc/uid/TP40008793-CH101-SW1), [Configuring OpenGL ES Contexts](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithOpenGLESContexts/WorkingwithOpenGLESContexts.html#//apple_ßref/doc/uid/TP40008793-CH2-SW1)

### GLKit提供了绘图和动画支持
UIKit提供了UIViewController和UIView去控制视图的展示，跳转交互。

GLKit也提供了类似的支持，如GLKView对象负责渲染OpenGL ES内容，GLKViewController对象负责管理视图

> Relevant Chapters: [Drawing with OpenGL ES and GLKit](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/DrawingWithOpenGLES/DrawingWithOpenGLES.html#//apple_ref/doc/uid/TP40008793-CH503-SW1)

### 替换绘制对象

> Relevant Chapters: [Drawing to Other Rendering Destinations](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithEAGLContexts/WorkingwithEAGLContexts.html#//apple_ref/doc/uid/TP40008793-CH103-SW1)

### 性能调优相关

> Relevant Chapters: [OpenGL ES Design Guidelines](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/OpenGLESApplicationDesign/OpenGLESApplicationDesign.html#//apple_ref/doc/uid/TP40008793-CH6-SW1), [Best Practices for Working with Vertex Data](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/TechniquesforWorkingwithVertexData/TechniquesforWorkingwithVertexData.html#//apple_ref/doc/uid/TP40008793-CH107-SW1), [Best Practices for Working with Texture Data](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/TechniquesForWorkingWithTextureData/TechniquesForWorkingWithTextureData.html#//apple_ref/doc/uid/TP40008793-CH104-SW1), [Best Practices for Shaders](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/BestPracticesforShaders/BestPracticesforShaders.html#//apple_ref/doc/uid/TP40008793-CH7-SW3), [Tuning Your OpenGL ES App](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Performance/Performance.html#//apple_ref/doc/uid/TP40008793-CH105-SW1)

### 不能在后台调用OpenGL ES的函数
> Relevant Chapters: [Multitasking, High Resolution, and Other iOS Features](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ImplementingaMultitasking-awareOpenGLESApplication/ImplementingaMultitasking-awareOpenGLESApplication.html#//apple_ref/doc/uid/TP40008793-CH5-SW1)

### OpenGL ES多线程
多线程中，不能同时访问，相同的OpenGL上下文

> Relevant Chapters: [Concurrency and OpenGL ES](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ConcurrencyandOpenGLES/ConcurrencyandOpenGLES.html#//apple_ref/doc/uid/TP40008793-CH409-SW2)















