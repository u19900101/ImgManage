<html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
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

    <%--/* textarea 自适应父容器大小 */--%>
    <style>

        .comments {
            width: 100%; /*自动适应父布局宽度*/
            height: 100%; /*自动适应父布局宽度*/
            overflow: auto;
            word-break: break-all;
            /*background-color: yellow;*/
            font-size: 2em;
            font-weight: bold;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            border: 1px solid black;"
        }

        span,input{
            font-size: 2em;
            font-weight: bold;
            font-family: Verdana, Arial, Helvetica, sans-serif;
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
    <form action="picture/update">
        <%--显示 照片名称  拍摄时间 地点--%>
        <div class="c1">
            <span>照片名称：</span><input id="pname" name = "pname" value="${picture.pname}" picpath = ${picture.path} pictype=${type}>
            <input id="pid" name = "pid" value="${picture.pid}" type="hidden">
            <input id="pictype" name = "pictype" value="${type}" type="hidden">
            <%--提示是否有重名的信息  错误信息  跟上面对应起来要写class--%>
            <span class="errorMsg" style="color: red;"></span>

            <span>拍摄时间：</span>
            <c:if test="${empty picture.pcreatime}">
                <span tyle="color: darksalmon">神秘时间</span>
            </c:if>
            <c:if test="${not empty picture.pcreatime}">
                <span style="color: darksalmon">${picture.pcreatime}</span>
            </c:if>

            <span>坐标：</span>
            <c:if test="${empty picture.gpsLongitude}">
                <span style="color: green">神秘未知</span>
            </c:if>
            <c:if test="${not empty picture.gpsLongitude}">
                <span style="color: green">${picture.gpsLongitude}</span>
                <span style="color: green">${picture.gpsLatitude}</span>
            </c:if>


            <input type="submit" value="提交">

        </div>
        <%--显示照片--%>
        <div class="c2">
            <img src="${picture.path}" width="800">
        </div>
        <%--添加描述--%>
        <div class="c3" >
            <c:if test="${empty picture.pdesc}">
                  <textarea class="comments" rows="4" cols="50"
                            placeholder="从我这里可以添加描述鸟..."
                            id = "pdesc"
                            name = "pdesc"
                  ></textarea>
            </c:if>
            <c:if test="${not empty picture.pdesc}">
                  <textarea class="comments" rows="4" cols="50"
                            id = "pdesc"
                            name = "pdesc"
                  >${picture.pdesc}</textarea>
            </c:if>


        </div>

    </form>
</div>

</html>
