

[前面](/2013/12/31/jsr330.html)提到[Spring](http://spring.io/)支持[JSR330](https://jcp.org/en/jsr/detail?id=330)。

在JSR330中定义的[依赖注入的标准注解](/2013/12/31/jsr330.html#menuIndex3)之外，Spring还扩展了自己的一些注解，对对象进行更精细的声明。


不仅如此，
Spring3的基于注解实现Bean依赖注入支持如下三种注解：

   * Spring自带依赖注入注解： Spring自带的一套依赖注入注解；
   * JSR-250注解：Java平台的公共注解，是Java EE 5规范之一，在JDK6中默认包含这些注解，从Spring2.5开始支持。
   * JSR-330注解：Java 依赖注入标准，Java EE 6规范之一，可能在加入到未来JDK版本，从Spring3开始支持；
   * JPA注解：用于注入持久化上下文和尸体管理器。




# @Inject --> @Autowired

  @Inject没有“required”属性

  自动装配


       自动装配就是指由Spring来自动地注入依赖对象，无需人工参与。
自动装配的好处是减少构造器注入和setter注入配置 

       目前Spring3.0支持“no”、“byName ”、“byType”、“constructor”四种自动装配，默认是“no”指不支持自动装配的，
         一、default：表示使用默认的自动装配，默认的自动装配需要在<beans>标签中使用default-autowire属性指定，其支持“no”、“byName ”、“byType”、“constructor”四种自动装配，如果需要覆盖默认自动装配，请继续往下看；
二、no：意思是不支持自动装配，必须明确指定依赖。
三、byName：根据名字进行自动装配，只能用于setter注入。比如我们有方法“setHelloApi”，则“byName”方式Spring容器将查找名字为helloApi的Bean并注入，如果找不到指定的Bean，将什么也不注入。
      四、“byType”：通过设置Bean定义属性autowire="byType"，意思是指根据类型注入，用于setter注入，比如如果指定自动装配方式为“byType”，而“setHelloApi”方法需要注入HelloApi类型数据，则Spring容器将查找HelloApi类型数据，如果找到一个则注入该Bean，如果找不到将什么也不注入，如果找到多个Bean将优先注入<bean>标签“primary”属性为true的Bean，否则抛出异常来表明有个多个Bean发现但不知道使用哪个。让我们用例子来讲解一下这几种情况吧。
       1）根据类型只找到一个Bean，此处注意了，在根据类型注入时，将把当前Bean自己排除在外，即如下配置中helloApi和bean都是HelloApi接口的实现，而“bean”通过类型进行注入“HelloApi”类型数据时自己是排除在外的，
       2）根据类型找到多个Bean时，对于集合类型（如List、Set）将注入所有匹配的候选者，而对于其他类型遇到这种情况可能需要使用“autowire-candidate”属性为false来让指定的Bean放弃作为自动装配的候选者，或使用“primary”属性为true来指定某个Bean为首选Bean：
       2.1）通过设置Bean定义的“autowire-candidate”属性为false来把指定Bean后自动装配候选者中移除：
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl"/>
<!-- 从自动装配候选者中去除 -->
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl"
autowire-candidate="false"/>
<bean id="bean1" class="cn.javass.spring.chapter3.bean.HelloApiDecorator"
    autowire="byType"/>

       2.2）通过设置Bean定义的“primary”属性为false来把指定自动装配时候选者中首选Bean：
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl"/>
<!-- 自动装配候选者中的首选Bean-->
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl" primary="true"/>
<bean id="bean" class="cn.javass.spring.chapter3.bean.HelloApiDecorator"
    autowire="byType"/>
五、“constructor”：通过设置Bean定义属性autowire="constructor"，功能和“byType”功能一样，根据类型注入构造器参数，只是用于构造器注入方式，直接看例子吧：

<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl"/>
<!-- 自动装配候选者中的首选Bean-->
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl" primary="true"/>
<bean id="bean"
    class="cn.javass.spring.chapter3.bean.HelloApiDecorator"
    autowire="constructor"/>

六、autodetect：自动检测是使用“constructor”还是“byType”自动装配方式，已不推荐使用。如果Bean有空构造器那么将采用“byType”自动装配方式，否则使用“constructor”自动装配方式。此处要把3.0的xsd替换为2.5的xsd，否则会报错。

<?xml version="1.0" encoding="UTF-8"?>
<beans  xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:context="http://www.springframework.org/schema/context"
        xsi:schemaLocation="
          http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
          http://www.springframework.org/schema/context
          http://www.springframework.org/schema/context/spring-context-2.5.xsd">
<bean class="cn.javass.spring.chapter2.helloworld.HelloImpl"/>
  <!-- 自动装配候选者中的首选Bean-->
  <bean class="cn.javass.spring.chapter2.helloworld.HelloImpl" primary="true"/>
  <bean id="bean"
        class="cn.javass.spring.chapter3.bean.HelloApiDecorator"
        autowire="autodetect"/>
</beans>


       可以采用在“<beans>”标签中通过“default-autowire”属性指定全局的自动装配方式，即如果default-autowire=”byName”，将对所有Bean进行根据名字进行自动装配。

不是所有类型都能自动装配：

   * 不能自动装配的数据类型：Object、基本数据类型（Date、CharSequence、Number、URI、URL、Class、int）等；
   * 通过“<beans>”标签default-autowire-candidates属性指定的匹配模式，不匹配的将不能作为自动装配的候选者，例如指定“*Service，*Dao”，将只把匹配这些模式的Bean作为候选者，而不匹配的不会作为候选者；
   * 通过将“<bean>”标签的autowire-candidate属性可被设为false，从而该Bean将不会作为依赖注入的候选者。

数组、集合、字典类型的根据类型自动装配和普通类型的自动装配是有区别的：

   * 数组类型、集合（Set、Collection、List）接口类型：将根据泛型获取匹配的所有候选者并注入到数组或集合中，如“List<HelloApi> list”将选择所有的HelloApi类型Bean并注入到list中，而对于集合的具体类型将只选择一个候选者，“如 ArrayList<HelloApi> list”将选择一个类型为ArrayList的Bean注入，而不是选择所有的HelloApi类型Bean进行注入；
   * 字典（Map）接口类型：同样根据泛型信息注入，键必须为String类型的Bean名字，值根据泛型信息获取，如“Map<String, HelloApi> map” 将选择所有的HelloApi类型Bean并注入到map中，而对于具体字典类型如“HashMap<String, HelloApi> map”将只选择类型为HashMap的Bean注入，而不是选择所有的HelloApi类型Bean进行注入。

       自动装配我们已经介绍完了，自动装配能带给我们什么好处呢？首先，自动装配确实减少了配置文件的量；其次， “byType”自动装配能在相应的Bean更改了字段类型时自动更新，即修改Bean类不需要修改配置，确实简单了。

       自动装配也是有缺点的，最重要的缺点就是没有了配置，在查找注入错误时非常麻烦，还有比如基本类型没法完成自动装配，所以可能经常发生一些莫名其妙的错误，在此我推荐大家不要使用该方式，最好是指定明确的注入方式，或者采用最新的Java5+注解注入方式。所以大家在使用自动装配时应该考虑自己负责项目的复杂度来进行衡量是否选择自动装配方式。

       自动装配注入方式能和配置注入方式一同工作吗？当然可以，大家只需记住配置注入的数据会覆盖自动装配注入的数据。

       大家是否注意到对于采用自动装配方式时如果没找到合适的的Bean时什么也不做，这样在程序中总会莫名其妙的发生一些空指针异常，而且是在程序运行期间才能发现，有没有办法能在提前发现这些错误呢？接下来就让我来看下依赖检查吧。


@Autowired：自动装配
基于@Autowired的自动装配，默认是根据类型注入，可以用于构造器、字段、方法注入，使用方式如下：
@Autowired(required=true)
构造器、字段、方法
@Autowired默认是根据参数类型进行自动装配，且必须有一个Bean候选者注入，如果允许出现0个Bean候选者需要设置属性“required=false”，“required”属性含义和@Required一样，只是@Required只适用于基于XML配置的setter注入方式。
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

注意“initMessage(String message, ArrayList<String> list)”方法签名中为什么使用ArrayList而不是List呢？具体参考【3.3.3  自动装配】一节中的集合类型注入区别。


# @Named --> @Component， @Qualifier

  能够进行更细致的划分


Spring基于注解实现Bean定义支持如下三种注解：

   * Spring自带的@Component注解及扩展@Repository、@Service、@Controller；
   * JSR-250 1.1版本中中定义的@ManagedBean注解，是Java EE 6标准规范之一，不包括在JDK中，需要在应用服务器环境使用（如Jboss）
   * JSR-330的@Named注解

## @Component

基于@Component的@Repository、@Service、@Controller分别用于数据访问层，业务逻辑层和展现层。
此外，还可以自定义注解，通过@Manager

@Service本身就是被@Componet这个元注解(meta annotaion)标注的。因此对于这三个层的Bean, spring的文档也推荐将它们标注为@Service, @Controller与@Repository，因为这样更方便其它工具对这些特殊Bean的处理以及为它们加上相关AOP的 aspects，spring在后续版本的升级上也可能对它们增加更多的特殊语义。比如，对于@Repository，spring会自动加上exception translation，用于转化持久层抛出的异常。



有些注解运行放置在多个地方，如@Named允许放置在类型、字段、方法参数上等，因此一般情况下放置在类型上表示定义，放置在参数、方法等上边一般代表使用（如依赖注入等等）。



一、@Component：定义Spring管理Bean，使用方式如下：
@Component("标识符")
POJO类
  在类上使用@Component注解，表示该类定义为Spring管理Bean，使用默认value（可选）属性表示Bean标识符。
package cn.javass.spring.chapter12;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
@Component("component")
public class TestCompoment {
    @Autowired
    private ApplicationContext ctx;
    public ApplicationContext getCtx() {
        return ctx;
    }
}



二、@Repository：@Component扩展，被@Repository注解的POJO类表示DAO层实现，从而见到该注解就想到DAO层实现，使用方式和@Component相同；
package cn.javass.spring.chapter12.dao.hibernate;
import org.springframework.stereotype.Repository;
@Repository("testHibernateDao")
public class TestHibernateDaoImpl {

}
三、@Service：@Component扩展，被@Service注解的POJO类表示Service层实现，从而见到该注解就想到Service层实现，使用方式和@Component相同；
package cn.javass.spring.chapter12.service.impl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import cn.javass.spring.chapter12.dao.hibernate.TestHibernateDaoImpl;
@Service("testService")
public class TestServiceImpl {
    @Autowired
    @Qualifier("testHibernateDao")
    private TestHibernateDaoImpl dao;
    public TestHibernateDaoImpl getDao() {
        return dao;
    }
}
四、@Controller：@Component扩展，被@Controller注解的类表示Web层实现，从而见到该注解就想到Web层实现，使用方式和@Component相同；
package cn.javass.spring.chapter12.action;
//省略import
@Controller
public class TestAction {
    @Autowired
    private TestServiceImpl testService;  
    public void list() {
        //调用业务逻辑层方法
    }
}

大家是否注意到@Controller中并没有定义Bean的标识符，那么默认Bean的名字将是以小写开头的类名（不包括包名），即如“TestAction”类的Bean标识符为“testAction”。

六、自定义扩展：Spring内置了三种通用的扩展注解@Repository、@Service、@Controller ，大多数情况下没必要定义自己的扩展，在此我们演示下如何扩展@Component注解来满足某些特殊规约的需要；

在此我们可能需要一个缓存层用于定义缓存Bean，因此我们需要自定义一个@Cache的注解来表示缓存类。

1、扩展@Component：
package cn.javass.spring.chapter12.stereotype;
//省略import
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Cache{
      String value() default "";
}
    扩展十分简单，只需要在扩展的注解上注解@Component即可，@Repository、@Service、@Controller也是通过该方式实现的，没什么特别之处

package cn.javass.spring.chapter12.cache;
@Cache("cache")
public class TestCache {

}



## @Qualifier：限定描述符，用于细粒度选择候选者；

@Autowired默认是根据类型进行注入的，因此如果有多个类型一样的Bean候选者，则需要限定其中一个候选者，否则将抛出异常，
@Qualifier限定描述符除了能根据名字进行注入，但能进行更细粒度的控制如何选择候选者，具体使用方式如下：
@Qualifier(value = "限定标识符")
字段、方法、参数

（1）、根据基于XML配置中的<qualifier>标签指定的名字进行注入，使用如下方式指定名称：
<qualifier  type="org.springframework.beans.factory.annotation.Qualifier"  value="限定标识符"/>

其中type属性可选，指定类型，默认就是Qualifier注解类，name就是给Bean候选者指定限定标识符，一个Bean定义中只允许指定类型不同的<qualifier>，如果有多个相同type后面指定的将覆盖前面的。
package cn.javass.spring.chapter12;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

public class TestBean31 {
    private DataSource dataSource;
    @Autowired
    //根据<qualifier>标签指定Bean限定标识符
    public void initDataSource(@Qualifier("mysqlDataSource") DataSource dataSource) {
        this.dataSource = dataSource;
    }
    public DataSource getDataSource() {
        return dataSource;
    }
}

（2）、缺省的根据Bean名字注入：最基本方式，是在Bean上没有指定<qualifier>标签时一种容错机制，即缺省情况下使用Bean标识符注入，但如果你指定了<qualifier>标签将不会发生容错。

package cn.javass.spring.chapter12;
//省略import
public class TestBean32 {
    private DataSource dataSource;
    @Autowired
    @Qualifier(value = "mysqlDataSource2") //指定Bean限定标识符
    //@Qualifier(value = "mysqlDataSourceBean")
    //是错误的注入，不会发生回退容错，因为你指定了<qualifier>
    public void initDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    public DataSource getDataSource() {
        return dataSource;
    }
}
默认情况下（没指定<qualifier>标签）@Qualifier的value属性将匹配Bean 标识符。

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
  

# @Singleton --> @Scope

	可以定义@Scope("singleton")等多种作用域 


@Scope：定义Bean作用域，默认单例，使用方式如下：
@Component("component")
@Scope("singleton")
public class TestCompoment {
……
}



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


# @Required：依赖检查


自动装配，很可能发生没有匹配的Bean进行自动装配，如果此种情况发生，只有在程序运行过程中发生了空指针异常才能发现错误，如果能提前发现该多好啊，这就是依赖检查的作用。
依赖检查：用于检查Bean定义的属性都注入数据了，不管是自动装配的还是配置方式注入的都能检查，如果没有注入数据将报错，从而提前发现注入错误，只检查具有setter方法的属性。


依赖检查有none、simple、object、all四种方式
一、none：默认方式，表示不检查；
二、objects：检查除基本类型外的依赖对象
三、simple：对基本类型进行依赖检查，包括数组类型，其他依赖不报错
四、all：对所以类型进行依赖检查


基于@Required的依赖检查表示注解的setter方法必须，即必须通过在XML配置中配置setter注入，如果没有配置在容器启动时会抛出异常从而保证在运行时不会遇到空指针异常，@Required只能放置在setter方法上，且通过XML配置的setter注入，可以使用如下方式来指定：
java代码：
package cn.javass.spring.chapter12;
public class TestBean {
    private String message;
    @Required
    public void setMessage(String message) {
        this.message = message;
    }
    public String getMessage() {
        return message;
    }
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

# 其他

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