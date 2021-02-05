<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <style>
        .app{
            width:100%;
            height:100%;
            overflow: scroll;
        }
        .c1{
            border: 1px solid red;
        }

        .c2{
            float: left;
            border: 2px solid green;
            height:100%;
            width: 60%;;
            display: inline-block;

            top: 10px;
            left: 0;
            right: 0;
            bottom: 0;
            margin: auto;
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
            /*为了效果明显，可以将如下边框打开，看一下效果*/
            border:1px solid red;
        }
        .c2 img{
            width:auto;
            height:100%;
          /*  width:100%;
            height:auto;*/
        }

        .c3{
            float: right;
            border: 1px solid gold;
            display: inline-block;
            width:39%;
            height: 100%;
        }
    </style>
    <script type="text/javascript">
        // 页面加载完成之后
        $(function () {
            // 使用ajax给用户名 实时 返回信息
            $("#pname").bind("input propertychange",function(event){
                var pname = this.value;
                var picpath = $(this).attr('picpath');
                var pictype = $(this).attr('pictype');
                // alert(pictype);
                $.post(
                    "${basePath}picture/ajaxexistPname",
                    "pname="+pname+"&picpath="+picpath+"&pictype="+pictype,
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

<%--显示大图--%>
<div class="app">
    <div class="c1">
        照片名称：<input id="pname" value="${picture.pname}" picpath = ${picture.path} pictype=${type}>
        <%--提示是否有重名的信息  错误信息  跟上面对应起来要写class--%>
        <span class="errorMsg" style="color: red;"></span>
        拍摄时间：
        <c:if test="${empty picture.pcreatime}">
            <span tyle="color: darksalmon">神秘时间</span>
        </c:if>
        <c:if test="${not empty picture.pcreatime}">
            <span style="color: darksalmon">${picture.pcreatime}</span>
        </c:if>

        坐标：
        <c:if test="${empty picture.plocal}">
        <span style="color: green">神秘未知</span>
        </c:if>
        <c:if test="${not empty picture.plocal}">
            <span style="color: green">${picture.plocal}</span>
        </c:if>

    </div>
    <div class="c2">
        <img src="${picture.path}" >

    </div>
    <div class="c3" >
        <%--现实照片拍摄的时间--%>
        <h2 align="center" style="color: seagreen" >添加描述</h2>　

    </div>
</div>

</html>
