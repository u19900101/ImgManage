<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
    <style>
        .BigImg{
            width: 80%;
            height:80%;
            /*设置div居中*/
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
            /* 层叠显示在其上 */
            position: relative;
        }
        .BigInput{
            width: 80%;
            height:5%;
            /*设置div居中*/
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
            /* 层叠显示在其上 */
            position: relative;
        }

        /*控制div 里面 img 的大小*/
        .BigImg img{
            width:auto;
            height:100%;
        }
        .BigInput input{
            width:60%;
            height:auto;
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
<h1></h1>
<div id="big_img_div">
    <div class="BigInput" >
        <input id="pname" value="${picture.pname}" picpath = ${picture.path} pictype=${type}>
        <%--提示是否有重名的信息  错误信息  跟上面对应起来要写class--%>
        <span class="errorMsg" style="color: red"></span>
    </div>
    <div class="BigImg" >
        <img id="show" src="${picture.path}"/>
    </div>
</div>


</html>
