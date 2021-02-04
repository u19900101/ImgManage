<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/1
  Time: 16:42
  To change this template use File | Settings | File Templates.
--%>
<%-- 静态包含 base标签、css样式、jQuery文件 --%>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <title>Title</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <%--/*设置div属性*/--%>
    <style>

        .c1{
            float: left;
            border: 1px solid red;
        }

        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

    </style>



    <%--点击显示大图和标题--%>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>

</head>
<body>

<%--
Picture{
pid=14,
path='D:\MyJava\mylifeImg\src\main\webapp\static\0E4A2352.jpg',
pname='0E4A2352.jpg',
pcreatime='2020:10:06 08:08:14',
plocal='null', plabel='null',
pdesc='还未设置'
}
--%>
<%--完美解决 图片的页面显示问题--%>
<div style="width:100%;height:100%;overflow: scroll;">
    <div class="panel-group" id="accordion">
        <c:forEach var="item" items="${info}">
            <%--月份的div框--%>
            <div class="c2">
                <div class="panel panel-default">
                    <%--折叠月份的标题--%>
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion"
                               href="#${item.key}">
                                <%--拍摄时间--%>
                                <h2 style="color: chocolate">${item.key}</h2>
                            </a>
                        </h4>
                    </div>
                    <%--折叠月度照片--%>
                    <div id="${item.key}" class="panel-collapse collapse">
                        <div class="panel-body">

                            <c:forEach items="${item.value}" var="picture" >
                                <div class="c1">
                                    <%--现实照片拍摄的时间--%>
                                    <h2 align="center" style="color: seagreen">${picture.pcreatime}</h2>　

                                        <a href="picture/before_edit_picture?pid=${picture.pid}">
                                            <img src="${picture.path}" height="300px" >
                                        </a>

                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <%--清除div的格式 以便于每月的图片另起一行显示--%>
                <div style="clear: both"></div>
            </div>
        </c:forEach>
    </div>
    <%-- 此方法 默认第一个显示 其余的折叠  不知其所以然--%>
    <script type="text/javascript">
        $(function () {
            $('.collapse').collapse('hidden');
        });
    </script>
</div>

</div>

</body>
</html>
