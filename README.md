HelloWorlManage
===============

iOS版积分墙聚合


  各位同事可以把本套工具维护起来，目前此聚合只提供了简单的基础功能，若无法实现你的需求，那么请自行编写，并把本工具维护起来，提交后我看看没有问题的话，就会把代码合并进来。目前1.0版本里面只有4家积分墙，可自行添加，添加完维护起来。
  
    本版本由于是内部使用，相关的依赖文件我就不上传了，请根据报错信息，自行添加就可以了，当然都是符合我们公司的开发风格的，很方便添加的，比如说UMeng的组件什么的，你原本的项目里面一定会有。以后有空我会上传一个Demo，完善文档以及完善这个聚合的功能。至于framework的添加，请根据你所使用的积分墙平台自行添加。  

    使用过程中有什么问题，直接和我联系。

原理，为各积分墙SDK封装通用的接口之后由manage统一管理。

使用方法
    为某平台SDK编写适配后，将适配代码已经SDK放入工程，修改配置即可。
    删除某平台，只需修改配置及移除文件即可。


1.0版本

  1：实现积分墙聚合，提供统一管理各平台查询、消费积分的功能，可直接指定显示某平台，也可以在线配置随机显示比例。
    目前包含积分墙SDK：
      A：点入
      B：触控
      c：有米
      D：安沃
