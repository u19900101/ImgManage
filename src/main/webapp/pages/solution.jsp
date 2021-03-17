<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>

    <style media="screen">
     .wrapper {
         display: flex;
         width: 100%;
     }

    .left {
        width: 20%;
        height: 100vh;
        overflow: auto;
    }
     .right {
        width: 80%;
        height: 100vh;
        overflow: auto;
    }

    </style>
</head>
<body>
<div class="wrapper" id="page">

    <div class="left" id = "leftPage" style="border: 1px solid green">
        <button id="showAllPic">
            <span class="glyphicon glyphicon-tags" style="font-size:15px;" ></span>
            查看所有
        </button>

        <button id="faceDetect">
            <span class="glyphicon glyphicon-tags" style="font-size:15px;" ></span>
            人脸检测
        </button>

        <div id="jstree">

        </div>
    </div>
    <div class="right" id = "rightPage" style="border: 1px solid red">

       <%-- 右侧页面显示区域 --%>


    </div>
        <%--右边页面点击 删除标签时 更新到主页面 --%>
    <input type="hidden" id="updateTags">
</div>

<script>
    $(function () {

        onload();
        function onload() {
            $("#jstree").load("label/getLabelTree");
            // 在picture页面加载tree，解决刚进来时点击出现bug
            $("#rightPage").load("picture/page");
        };

        $("#showAllPic").on("click",function () {
            onload();
        });

        $("#faceDetect").on("click",function () {
            $.post(
                "http://localhost:8080/pic/face/detectAllPicFace",

                function(data) {
                   console.log("操作完成...")
                },
                "json"
            );
        })
    });

</script>

</body>
</html>