# JnuNews 校园新闻客户端
网上看到[mexiQQ](https://github.com/mexiQQ)的一个[类新闻客户端开源代码](https://github.com/mexiQQ/VReader-iOS), 便研究了下在其基础上做了些修改，给自己学校做了个校园资讯新闻的客户端。模块方面采用自定义的tableViewCell，如：

![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cell1.png)

![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cell2.png)

图片通过UIImageView+AFNetworking.h下的setImageWithURL:方法异步加载并显示图片

</br>
***相关技术实现：***

1. 新闻资讯模块（校园招聘、实习兼职、礼堂观影、校内通知...）

2. Bmob云服务

3. Pods管理第三方库（AFNetworking、BmobSDK）

4. 数据持久化

</br>
***第三方开源库：***

1. [AFNetworking](https://github.com/AFNetworking/AFNetworking) 安装使用参考其github首页

2. [BmobSDK](http://www.bmob.cn/) 使用参考其官网

3. [SWRevealViewController](https://github.com/John-Lluch/SWRevealViewController) 其github上面有使用案例与教程

</br>
效果图：

![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cover1.png)
![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cover2.png)
![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cover3.png)
![image](https://github.com/yankwan/JnuNews/raw/master/Readme/cover4.png)

</br>
后期将添加用户注册相关功能，如第三方注册，分享评论等...
