---
layout: post
title: "Sping中定义的注解"
description: "使用注解的好处是减少配置。结合基于Java代码的容器配置，可以实现“零配置”。"
category: 软件开发
tags: [spring]
lastmod: 
---

[前面](/2013/12/31/jsr330.html)提到[Spring](http://spring.io/)支持
[JSR330](https://jcp.org/en/jsr/detail?id=330)中定义的[依赖注入的标准注解](/2013/12/31/jsr330.html#menuIndex3)。

Spring从2.5开始，还支持[JSR250](https://jcp.org/en/jsr/detail?id=250)(Common Annotations for the JavaTM Platform)注解，以及[JSR317](JavaTM Persistence 2.0)中的[JPA注解](/2012/12/30/JPA.html)。

不仅如此，Spring还扩展了自己的一些注解，能够进行更精细的声明。

使用注解的好处是减少配置。结合[基于Java代码的容器配置](/2014/01/01/spring_Java_based_container_configuration.html)，可以实现“零配置”。

本文介绍Spring中定义的一些注解。

# 标记bean

[JSR330](https://jcp.org/en/jsr/detail?id=330)中没有约定bean的注解，需要注入（`@Inject`）的地方，通过`[@Named](/2013/12/31/jsr330.html#menuIndex3)`限定器指定需要注入的接口类型。

在Spring中，定义了`@Component`、`@Repository`、`@Service`、`@Controller`等注解，用于标记bean：

- `@Component`： 是一个泛化的概念，仅仅表示一个组件 (Bean) ，可以作用在任何层次。
- `@Service`： 通常作用在业务层，但是目前该功能与 @Component 相同。
- `@Controller`： 通常作用在控制层，但是目前该功能与 @Component 相同。
- `@Repository`：通常用在数据访问层的DAO类上。Spring会将该注解标记的类中抛出的数据访问异常封装为 Spring 的数据访问异常类型。

此外，Spring还允许自定义bean的注解类型。比如，如果自定义一个@Cache的注解来表示缓存类:

```

//定义注解类型
package my.app.stereotype;
……
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Cache{
      String value() default "";
}


//使用自定义注解

@Cache("cache")
public class TestCache {

}

```

# bean作用域

[JSR330](https://jcp.org/en/jsr/detail?id=330)中只定义了`[@Singleton](/2013/12/31/jsr330.html#menuIndex3)`，标记singleton作用域；
spring提供“singleton”和“prototype”两种基本作用域，以及“request”、“session”、“global session”三种web作用域；
Spring还允许用户定制自己的作用域。作用域的作用是标记Bean对象相对于其他Bean对象的请求可见范围。

+ 基本作用域

  - singleton
  
    Bean在容器中只有一个实例，其整个生命周期交由容器管理。Spring使用注册表模式实现singleton模式，不需要在bean代码中用编程方式实现。
  
  - prototype
  
    每次请求bean时容器创建并返回该bean的一个新的实例。

+ Web作用域

  Web作用域只有在应用处于Web环境、并且在Web容器中配置对应的监听器或拦截器之后才会生效。包括：

  
  - request
    
    每个http请求创建一个新的Bean，比如Form表单数据对象。

  - session

    表示每个会话创建一个新的Bean。比如当前用户的用户信息对象。

  - globalSession

    用于portlet环境。如果在非portlet环境，等同于session作用域。

在Spring中，作用域用`@Scpoe`进行标记。比如：

```
@Scope("prototype") 
@Repository 
public class Demo { … }
```

# 自动装配

自动装配是指根据一定的策略，自动注入依赖对象，无需人工参与。使用自动装配可以减少构造器注入和setter注入配置。

Spring可以使用[JSR250规定的`@Resource`、`@Qualifier`注解]()处理自动装配，
也可以使用Spring自身的`@Autowired`和`@Qualifier`的组合。

`@Autowired`用于根据类型进行装配。该注解可以用于 Setter 方法、构造函数、字段，甚至普通方法，前提是方法必须有至少一个参数。

`@Autowired`可以用于数组和使用泛型的集合类型。然后 Spring 会将容器中所有类型符合的 Bean 注入进来。
`@Autowired`标注作用于 Map 类型时，如果 Map 的 key 为 String 类型，则 Spring 会将容器中所有类型符合 Map 的 value 对应的类型的 Bean 增加进来，用 Bean 的 id 或 name 作为 Map 的 key。

`@Autowired`标注作用于普通方法时，会产生一个副作用，就是在容器初始化该 Bean 实例的时候就会调用该方法。当然，前提是执行了自动装配，对于不满足装配条件的情况，该方法也不会被执行。

当标注了`@Autowired`后，自动注入不能满足，则会抛出异常。我们可以给 @Autowired 标注增加一个 required=false 属性，以改变这个行为。

另外，每一个类中只能有一个构造函数的 @Autowired.required() 属性为 true。否则就出问题了。如果用 @Autowired 同时标注了多个构造函数，那么，Spring 将采用贪心算法匹配构造函数 ( 构造函数最长 )。

@Autowired 还有一个作用就是，如果将其标注在 BeanFactory 类型、ApplicationContext 类型、ResourceLoader 类型、ApplicationEventPublisher 类型、MessageSource 类型上，那么 Spring 会自动注入这些实现类的实例，不需要额外的操作。

JSR330中只定义了一个`@Named`注解，可以根据bean的ID进行限定；
当容器中存在多个 Bean 的类型与需要注入的相同时，注入将不能执行，我们可以给 @Autowired 增加一个候选值，做法是在 @Autowired 后面增加一个 @Qualifier 标注，提供一个 String 类型的值作为候选的 Bean 的名字。举例如下：

@Autowired(required=false) 
@Qualifier("ppp") 
public void setPerson(person p){}

@Qualifier 甚至可以作用于方法的参数 ( 对于方法只有一个参数的情况，我们可以将 @Qualifer 标注放置在方法声明上面，但是推荐放置在参数前面 )，举例如下：

```
@Autowired(required=false) 
public void sayHello(@Qualifier("ppp")Person p,String name){}
```

如果 @Autowired 注入的是 BeanFactory、ApplicationContext、ResourceLoader 等系统类型，那么则不需要 @Qualifier，此时即使提供了 @Qualifier 注解，也将会被忽略；而对于自定义类型的自动装配，如果使用了 @Qualifier 注解并且没有名字与之匹配的 Bean，则自动装配匹配失败。



# 依赖检查

使用自动装配，很可能发生没有装配成功的情况。通常，在运行时(runtime)才会发现错误（比如空指针异常）。

为了能够提前发现装配错误，Spring提供了`@Required`注解用于依赖检查。

`@Required`注解应用在setter方法上，其机制 **不是** 判断字段值是否存在，
而是判断是否调用了setter方法。`@Required`也不检查setter方法的有效性。即使注入了"null"，也认为执行了注入。

如果标注了`@Required`的Setter方法没有被调用，则 Spring 在解析的时候会抛出异常。

##########

## @Qualifier：限定描述符，用于细粒度选择候选者；


（3）、扩展@Qualifier限定描述符注解：对@Qualifier的扩展来提供细粒度选择候选者；

具体使用方式就是自定义一个注解并使用@Qualifier注解其即可使用。

首先让我们考虑这样一个问题，如果我们有两个数据源，分别为Mysql和Oracle，因此注入两者相关资源时就牵扯到数据库相关，如在DAO层注入SessionFactory时，当然可以采用前边介绍的方式，但为了简单和直观我们希望采用自定义注解方式。

1、扩展@Qualifier限定描述符注解来分别表示Mysql和Oracle数据源
package cn.javass.spring.chapter12.qualifier;
import org.springframework.beans.factory.annotation.Qualifier;
/** 表示注入Mysql相关 */
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Mysql {
}

package cn.javass.spring.chapter12.qualifier;
import org.springframework.beans.factory.annotation.Qualifier;
/** 表示注入Oracle相关 */
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Oracle {
}

package cn.javass.spring.chapter12;
//省略import
public class TestBean33 {
    private DataSource mysqlDataSource;
    private DataSource oracleDataSource;
    @Autowired
    public void initDataSource(@Mysql DataSource mysqlDataSource, @Oracle DataSource oracleDataSource) {
        this.mysqlDataSource = mysqlDataSource;
        this.oracleDataSource = oracleDataSource;
    }
    public DataSource getMysqlDataSource() {
        return mysqlDataSource;
    }
    public DataSource getOracleDataSource() {
        return oracleDataSource;
    }
}

前边演示了不带属性的注解，接下来演示一下带参数的注解：

1、首先定义数据库类型：
package cn.javass.spring.chapter12.qualifier;
public enum DataBase {
    ORACLE, MYSQL;
}

2、其次扩展@Qualifier限定描述符注解
package cn.javass.spring.chapter12.qualifier;
//省略import
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface DataSourceType {
    String ip();      //指定ip,用于多数据源情况
    DataBase database();//指定数据库类型
}

3、准备测试Bean：
package cn.javass.spring.chapter12;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import cn.javass.spring.chapter12.qualifier.DataBase;
import cn.javass.spring.chapter12.qualifier.DataSourceType;
public class TestBean34 {
    private DataSource mysqlDataSource;
    private DataSource oracleDataSource;
    @Autowired
    public void initDataSource(
            @DataSourceType(ip="localhost", database=DataBase.MYSQL)
            DataSource mysqlDataSource,
            @DataSourceType(ip="localhost", database=DataBase.ORACLE)
            DataSource oracleDataSource) {
        this.mysqlDataSource = mysqlDataSource;
        this.oracleDataSource = oracleDataSource;
    }
      //省略getter方法  
}

4、在Spring配置文件（chapter12/dependecyInjectWithAnnotation.xml）添加如下Bean配置：
<bean id="testBean34" class="cn.javass.spring.chapter12.TestBean34"/>

5、在Spring修改定义的两个数据源：
<bean id="mysqlDataSourceBean" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
    <qualifier value="mysqlDataSource"/>
    <qualifier type="cn.javass.spring.chapter12.qualifier.Mysql"/>
    <qualifier type="cn.javass.spring.chapter12.qualifier.DataSourceType">
        <attribute key="ip" value="localhost"/>
        <attribute key="database" value="MYSQL"/>
    </qualifier>
</bean>
<bean id="oracleDataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
    <qualifier type="cn.javass.spring.chapter12.qualifier.Oracle"/>
    <qualifier type="cn.javass.spring.chapter12.qualifier.DataSourceType">
        <attribute key="ip" value="localhost"/>
        <attribute key="database" value="ORACLE"/>
    </qualifier>
</bean>
四、自定义注解限定描述符：完全不使用@Qualifier，而是自己定义一个独立的限定注解；

1、首先使用如下方式定义一个自定义注解限定描述符：
package cn.javass.spring.chapter12.qualifier;
//省略import
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface CustomQualifier {
    String value();
}

2、准备测试Bean：
package cn.javass.spring.chapter12;
//省略import
public class TestBean35 {
    private DataSource dataSoruce;
    @Autowired
    public TestBean35(@CustomQualifier("oracleDataSource") DataSource dataSource) {
        this.dataSoruce = dataSource;
    }
    public DataSource getDataSoruce() {
        return dataSoruce;
    }
}

3、在Spring配置文件（chapter12/dependecyInjectWithAnnotation.xml）添加如下Bean配置：
<bean id="testBean35" class="cn.javass.spring.chapter12.TestBean35"/>

4、然后在Spring配置文件中注册CustomQualifier自定义注解限定描述符，只有注册了Spring才能识别：
<bean id="customAutowireConfigurer" class="org.springframework.beans.factory.annotation.CustomAutowireConfigurer">
    <property name="customQualifierTypes">
        <set>
            <value>cn.javass.spring.chapter12.qualifier.CustomQualifier</value>
        </set>
  </property>
</bean>

5、测试方法如下：
@Test
public void testQualifierInject5() {
    TestBean35 testBean35 = ctx.getBean("testBean35", TestBean35.class);
    Assert.assertEquals(ctx.getBean("oracleDataSource"), testBean35.getDataSource());
}

    从测试中可看出，自定义的和Spring自带的没什么区别，因此如果没有足够的理由请使用Spring自带的Qualifier注解。

    到此限定描述符介绍完毕，在此一定要注意以下几点：

   * 限定标识符和Bean的描述符是不一样的；
   * 多个Bean定义中可以使用相同的限定标识符；
   * 对于集合、数组、字典类型的限定描述符注入，将注入多个具有相同限定标识符的Bean。
  




# @Inject --> @Autowired


构造器、字段、方法
（1）、构造器注入：通过将@Autowired注解放在构造器上来完成构造器注入，默认构造器参数通过类型自动装配，如下所示：
package cn.javass.spring.chapter12;
import org.springframework.beans.factory.annotation.Autowired;
public class TestBean11 {
    private String message;
    @Autowired //构造器注入
    private TestBean11(String message) {
        this.message = message;
    }
    //省略message的getter和setter
}
（2）、字段注入：通过将@Autowired注解放在构造器上来完成字段注入。
package cn.javass.spring.chapter12;
import org.springframework.beans.factory.annotation.Autowired;
public class TestBean12 {
    @Autowired //字段注入
    private String message;
    //省略getter和setter
}
（3）、方法参数注入：通过将@Autowired注解放在方法上来完成方法参数注入。
package cn.javass.spring.chapter12;
import org.springframework.beans.factory.annotation.Autowired;
public class TestBean13 {
    private String message;
    @Autowired //setter方法注入
    public void setMessage(String message) {
        this.message = message;
    }
    public String getMessage() {
        return message;
    }
}

package cn.javass.spring.chapter12;
//省略import
public class TestBean14 {
    private String message;
    private List<String> list;
    @Autowired(required = true) //任意一个或多个参数方法注入
    private void initMessage(String message, ArrayList<String> list) {
        this.message = message;
        this.list = list;
    }
    //省略getter和setter
}

方法参数注入除了支持setter方法注入，还支持1个或多个参数的普通方法注入，在基于XML配置中不支持1个或多个参数的普通方法注入，方法注入不支持静态类型方法的注入。


# @Value

@Value：注入SpEL表达式


三、@Value：注入SpEL表达式；
用于注入SpEL表达式，可以放置在字段方法或参数上，使用方式如下：
@Value(value = "SpEL表达式")
字段、方法、参数

1、可以在类字段上使用该注解：
@Value(value = "#{message}")
private String message;

2、可以放置在带@Autowired注解的方法的参数上：
@Autowired
public void initMessage(@Value(value = "#{message}#{message}") String message) {
    this.message = message;
}

3、还可以放置在带@Autowired注解的构造器的参数上：
@Autowired
private TestBean43(@Value(value = "#{message}#{message}") String message) {
    this.message = message;
}





# @Lazy


@Lazy：定义Bean将延迟初始化，使用方式如下：

@Component("component")
@Lazy(true)
public class TestCompoment {
……
}

    使用@Lazy注解指定Bean需要延迟初始化。


# @DependsOn：定义Bean初始化及销毁时的顺序


使用方式如下：
@Component("component")
@DependsOn({"managedBean"})
public class TestCompoment {
……
}

# 其他注解

12.3.6  提供更多的配置元数据
1、@Lazy：定义Bean将延迟初始化，使用方式如下：
 
java代码：
查看复制到剪贴板打印
@Component("component")  
@Lazy(true)  
public class TestCompoment {  
……  
}  
    使用@Lazy注解指定Bean需要延迟初始化。
 
 
2、@DependsOn：定义Bean初始化及销毁时的顺序，使用方式如下：
 
java代码：
查看复制到剪贴板打印
@Component("component")  
@DependsOn({"managedBean"})  
public class TestCompoment {  
……  
}  
 
 
3、@Scope：定义Bean作用域，默认单例，使用方式如下：
 
java代码：
查看复制到剪贴板打印
@Component("component")  
@Scope("singleton")  
public class TestCompoment {  
……  
}  
 
 
 
4、@Qualifier：指定限定描述符，对应于基于XML配置中的<qualifier>标签，使用方式如下：
 
java代码：
查看复制到剪贴板打印
@Component("component")  
@Qualifier("component")  
public class TestCompoment {  
……  
}  
    可以使用复杂的扩展，如@Mysql等等。
 
 
5、@Primary：自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常，使用方式如下：
 
java代码：
查看复制到剪贴板打印
@Component("component")  
@Primary  
public class TestCompoment {  
……  
}  

# 关于注解的其他说明

在Spring容器中开启注解驱动支持，即使用如下配置方式开启：

  <context:annotation-config/>



三种方式：java代码，配置文件(比如xml)，注解

基于XML配置中的依赖注入的数据将覆盖基于注解配置中的依赖注入的数据。



xml优先于注解

更详细的资料，参考[这里](http://www.ibm.com/developerworks/cn/opensource/os-cn-spring-iocannt/)