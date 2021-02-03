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
        .left{
            float:left;
            margin-left:50px;
            width:800px;
        }
        .right{
            margin-left:auto;
            text-align: center;

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
<div>
    <c:forEach items="${info.list}" var="picture">
        <div class="left">
            <img src="img/f1/${picture.pname}" height="600"><br/><br/>
        </div>

        <div class="right" >
            <br/><br/><br/><br/><br/><br/>
            <form action="picture/update" method="post" >
                文件名：<input name="pname" id="pname" picpath = ${picture.path}
                    value="${picture.pname}">
                <span class="errorMsg" style="color: red">${ requestScope.msg }</span><br/><br/>
                拍摄时间：<input name="pcreatime" value="${picture.pcreatime}"> <br/><br/>
                地理位置： <input name="plocal" value="${picture.plocal}"> <%--<br/>--%>
                <input name="pid" type="hidden" value="${picture.pid}"> <br/><br/>
                <input name="path" type="hidden" value="${picture.path}">

                描述<textarea name="pdesc"> </textarea><br/>
                <input type="submit" value="提交"/>
            </form>
        </div>
    </c:forEach>
    <%@include file="/pages/page_nav.jsp"%>

</div>





</div>

</body>
</html>
