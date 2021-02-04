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
    <style>
        /*设置div属性*/
        .c1{
            float: left;
            border: 1px solid red;
        }

        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

    </style>

    <script type="text/javascript">

        // 页面加载完成之后
        $(function () {
            // 使用ajax给用户名 实时 返回信息
            $("#pname").bind("input propertychange",function(event){
                var pname = this.value;
                var picpath = $(this).attr('picpath');
                $.post(
                    "${basePath}picture/ajaxexistPname",
                    "pname="+pname+"&picpath="+picpath,
                    function (data) {
                    if(data.existpname){
                        $("span.errorMsg").text("照片名称已存在，请重新输入");
                    }else {
                        $("span.errorMsg").text("照片名称可用");
                    }
                },
                    "json"
                );
            })
        });

    </script>
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
        <c:forEach var="item" items="${info}">
            <div class="c2">
                <h2 style="color: chocolate">${item.key}</h2>
                <c:forEach items="${item.value}" var="picture" >
                    <div class="c1">
                        <h1 style="color: seagreen">${picture.pcreatime}</h1>　
                        <img src="${picture.path}" height="300px">
                    </div>
                </c:forEach>
                <%--清除div的格式 以便于每月的图片另起一行显示--%>
                <div style="clear: both"></div>
            </div>

            <br/>

        </c:forEach>
    <%--<%@include file="/pages/page_nav.jsp"%>--%>

</div>





</div>

</body>
</html>
