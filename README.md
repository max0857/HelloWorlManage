HelloWorlManage
===============

iOS版积分墙聚合


	目前github也在学习过程中，这玩意排版不太会弄，在网页上看起来是，可checkout本文件后直接打开，是有
排版的。

	希望各位同事可以把本套工具维护起来，目前此聚合只提供了简单的基础功能，若无法实现你的需求，那么请自行
编写，并把本工具维护起来，提交后我看看没有问题的话，就会把代码合并进来。目前1.0版本里面只有4家积分墙，可自行添
加，添加完维护起来。
  	本版本由于是内部使用，相关的依赖文件我就不上传了，请根据报错信息，自行添加就可以了，当然都是符合我们
公司的开发风格的，很方便添加的，比如说UMeng的组件什么的（提交了一个版本降低了依赖，但是我们的积分墙配置是通过
UMeng在线参数获取的，所以一定要使用到UMeng的组件），你原本的项目里面一定会有。
	以后有空我会上传一个Demo，完善文档以及完善这个聚合的功能。
	至于framework的添加，请根据你所使用的积分墙平台自行添加。  
  
  	使用过程中有什么问题，直接和我联系。

	本工具原理简单来说就是为各积分墙SDK封装通用的接口之后由manage统一管理。

	1.0版本

  	1：实现积分墙聚合，提供统一管理各平台查询、消费积分的功能，可直接指定显示某平台，也可以在线配置随机
显示比例。
    		目前包含积分墙SDK：
      			A：点入
      			B：触控
      			c：有米
      			D：安沃

	使用方法：

	1：初始化积分墙

	本类为单件类。
	最好在[window makeKeyAndVisible];之后调用如下代码：
	
    		[HelloWorldManage defaultManage:“审核开发，请自行决定” window:window
 viewController:window.rootViewController];

	完成初始化以后想要得到实例调用[HelloWorldManage defaultManage]即可,不需要在传递任何参数，也
不能调用（希望：谁有空可以改下这个地方，即重复调用容错）.

	2：生命周期回调,在相应的接口里面调用如下方法：（这些方法并不是必须的，但你的确保你所使用的积分墙中没
有任何SDK需要得到生命周期的信息）
		
		这个地方需要注意的的是，生命周期事件会路由到各适配器中去，适配器中的相应方法定义为虚方法，
若子类适配器所对应的积分墙SDK需要得到生命周期事件，那么在适配器中实现父类定义的方法即可。
		

		-(void) applicationWillResignActive;


		-(void) applicationDidBecomeActive;


		-(void) applicationDidEnterBackground;


		-(void) applicationWillEnterForeground;

	3：展现积分墙：

		-(void) show:(NSString *) platName;
		-(void) show;
	   重载了两个方法，方法一：直接指定打开某个积分墙，platName又你自己对你增加的积分墙SDK自行定义
，目前以后的4个积分墙SDK的name定义可以参考源文件或HWdefaultConfig.txt
			方法二：根据配置比例随机打开某个积分墙，配置此几率时，各平台比例相加不要超过
100，不要有小数。

	4：积分操作
		-(int) queryScore;
		-(void) expenseScore:(int)score;
		-(void) addScore:(int) score;
	   分别为查询、消费、增加积分。

	**本聚合对积分的管理是这样的，适配器通过统一的接口查询到积分后马上消费，这里的消费实际上就是叫交由
manage去统一管理这些积分.

	5:关于配置
		通过在线参数获得配置，可能这个获得在线参数的地方，每个人使用的时候需要根据自己情况处理一
下， 这个问题我们目前是无法解决的，我们并没有专用的服务器。
		关于配置的格式，请参考HWdefaultConfig.txt。 HWdefaultConfig.txt中platforms字
段下是每个积分墙SDK的配置，若需要自行添加SDK，那么请根据实际情况配置，其他地方不要动。
		关于HWdefaultConfig.txt，这个文件是默认配置， 当没有在线获得参数的情况下使用这个配
置。

	6：关于更多细节
		关于更多细节请查阅头文件，里面的注释会比较详解。
		通过阅读本代码也可以更好的掌握本工具，同时最希望大家一起把它维护起来。