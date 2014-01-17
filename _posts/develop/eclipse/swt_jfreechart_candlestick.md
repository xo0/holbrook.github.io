---
layout: post
title: "在SWT中用JFreeChart实现K线图"
description: ""
category: 软件开发
tags: [ZeroMQ, 消息中间件]
lastmod: 
---

# 目标

在[R学习笔记](/2013/05/03/r_notes_1_what.html)中，展示了这样一张图表：

![](/images/2013/r_notes/2.png)

现在需要在Eclipse e4应用中实现这样的图表。

# SWT图表组件的选择

在RCP/JFace/SWT中，可以选择的图表组件包括：

- Eclipse BIRT

  [Eclipse BIRT](http://www.eclipse.org/birt/phoenix/)是Eclipse平台下的报表框架。其中的图表组件可以单独使用。
  由于BIRT依赖于GEF、EMF等Eclipse插件，所以非常重，不适合简单轻量的应用。 

- SWT Chart
 
  从名字就可以看出，[SWT Chart](http://www.swtchart.org/)是专为SWT环境开发的报表组件。设计很清晰，使用起来也方便。但是目前支持的图表类型比较少。

- JFreeChart

  [JFreeChart](http://www.jfree.org/jfreechart/)是Java世界的老牌图表组件，其强大无以言表。JFreeChart支持AWT、Swing等
GUI环境，也可以生成图片在Web环境中使用。后来又增加了对SWT环境的支持，从此不再需要SWT_AWT的桥接方式。


综上所述，这里选择JFreeChart作为绘图组件。



# 获取股票数据

由于需要的数据量比较大，不能再使用[前面]()的模拟数据方法了。这里使用[雅虎财经](http://finance.yahoo.com/)的数据。

雅虎财经提供了查询股票历史数据的接口：

```
  http://table.finance.yahoo.com/table.csv?ignore=.csv&....
```
参数包括：

- s: 股票代码/名称。对于国内的股票，使用类似`000001.ss`的编码
- a、b、c: 开始时间的月、日、年
- d、e、f: 结束时间的月、日、年
- g：时间周期，分别为`d`:日， `w`:周，`m`：月， `v`:dividends only

其中，月份是从0开始。比如，9月数据写为08。

本文中使用2013年上证综合指数的日线数据：

```
  http://table.finance.yahoo.com/table.csv?ignore=.csv&s=000001.ss&a=00&b=01&c=2013&d=11&e=31&f=2013&g=d
```

获取到的CSV文件包含的数据列为`Date,Open,High,Low,Close,Volume,Adj Close`，其中Date的格式为`yyyy-MM-dd`。数据按照日期倒序排列。

处理代码如下：

```
	OHLCSeries ohlcSeries = new OHLCSeries("");
	TimeSeries timeSeries =new TimeSeries("");
	
	try{
		URL url = new URL("http://table.finance.yahoo.com/table.csv?ignore=.csv&s=000001.ss&a=00&b=01&c=2013&d=11&e=31&f=2013&g=d");
		InputStream is = url.openStream();
		InputStreamReader reader = new InputStreamReader(is,"UTF-8");
		
		BufferedReader buffer = new BufferedReader(reader);
		
		
		String newLine = buffer.readLine();// 标题行
		
		
		while ((newLine = buffer.readLine()) != null) {
            String item[] = newLine.trim().split(",");
            Date date = df.parse(item[0]);
            float open = Float.valueOf(item[1]);
            float high = Float.valueOf(item[2]);
            float low = Float.valueOf(item[3]);
            float close = Float.valueOf(item[4]);
            float volume = Float.valueOf(item[5]);
            float adj_close = Float.valueOf(item[6]);
            
            ohlcSeries.add(new Day(date), open,high,low,close);
            timeSeries.add(new Day(date),volume);
        }
		
	}catch(Exception e){
		e.printStackTrace();
	}
```	




# 组合图表

