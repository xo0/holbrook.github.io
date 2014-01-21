JBoss Fuse: 如何开发Web Service

http://www.ops4j.org/pax/eclipse/update/
Pax - http://tux2323.github.com/pax-runner-update-site/


# 构建工具：Tycho 还是Maven Bundle Plugin？

Maven与OSGi天生就是冤家：Maven通过`pom.xml`描述一个产物的全部，而OSGi将这项工作交给了`MANIFEST.MF`。

如果仅仅是一些定义信息还好说，但是Maven和OSGi都希望能够描述产物的依赖关系，在使用Maven开发OSGi bundle的时候，就导致了一个问题：

依赖关系到底是在`pom.xml`中描述，还是在`MANIFEST.MF`中描述？

[前面提到的Tycho](/2014/01/08/build_osgi_bundle_with_tycho_maven_plugin.html)的思路是由`MANIFEST.MF`自行管理bundle的依赖关系，`pom.xml`只记录使用maven进行构建时需要的信息，比如maven工程的父子关系、打包时需要的bundle仓库及要发布的目标平台等。

Tycho的这种机制对Eclipse IDE比较友好，在开发期间完全使用IDE的机制进行开发和调试，只有在打包部署时才依赖maven。



[Apache Felix Maven Bundle Plugin](http://felix.apache.org/site/apache-felix-maven-bundle-plugin-bnd.html)
则使用另一套机制：使用Maven Bundle Plugin，在开发时可以没有`MANIFEST.MF`文件！Maven Bundle Plugin在`pom.xml`中复制了一套`MANIFEST.MF`的元数据，完全可以通过`pom.xml`文件中的定义生成出完整的`MANIFEST.MF`文件。

Maven Bundle Plugin的这种机制使得工程完全的”maven化”，更适合传统非OSGi开发人员的使用习惯。但是无法很好的利用IDE的开发和调试功能，比如，你可能需要自己搭建一个运行环境从IDE中调用。


两种方式可谓各有千秋。但是Tycho明显基于Equniox和Eclipse，比如，Tycho可以配置Eclipse p2站点作为bundle库。如果要使用Tycho开发和调试Felix，需要搭建一个Eclipse风格的p2站点，将Felix runtime和需要的各种bundle都放到该站点中并发布，然后[在Tycho中引用该站点](/2014/01/08/build_osgi_bundle_with_tycho_maven_plugin.html#menuIndex2)。更详细的说明可以参考[这里](http://vzurczak.wordpress.com/2013/02/27/a-target-platform-based-on-apache-felix/)。
而Felix Maven Bundle Plugin对于各种OSGi runtime的支持是相同的，由于完全基于maven，使用任何IDE开发bundle的效果都差不多。通常，Felix系的平台，如Karaf、Geronimo、Camel、ServiceMix、Fuse等，其例子都是使用Maven Bundle Plugin构建的。所以本文的JBoss Fuse系类中，也会使用Maven Bundle Plugin。

# 一个OSGi bundle

