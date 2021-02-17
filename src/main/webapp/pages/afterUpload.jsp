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
    <style>
        .zuiOut{
            border: 1px solid yellow;
            /* 不被子 div 撑开 */
            /*overflow:hidden;*/
            overflow: auto;
        }

        .outdiv{
            float: left;
            border: 1px solid red;
            width: 49%;
            height: auto;
            overflow: auto;
        }

        .imgdiv{
            float: left;
            border: 2px solid green;
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .imgdiv img {
            /*height:auto;*/
            width:100%;
        }

        span{
            border: 1px solid #39987c;
            width: 100%;
            font-size: larger;
        }

        span.firstSpan{
            float: left;
            width: 24%;
            align:right;
        }
    </style>
    <%-- alter style--%>
    <style>
        .alert {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            min-width: 200px;
            margin-left: -100px;
            z-index: 99999;
            padding: 15px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            color: #3c763d;
            background-color: #dff0d8;
            border-color: #d6e9c6;
            font-size: xx-large;
        }

        .alert-info {
            color: #31708f;
            background-color: #d9edf7;
            border-color: #bce8f1;
        }

        .alert-warning {
            color: #8a6d3b;
            background-color: #fcf8e3;
            border-color: #faebcc;
        }

        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }
    </style>
    <script type="text/javascript">
        $(function(){
            $('.myselect').on('click', function(){
                var handleMethod = $(this).attr('handleMethod');
                var uploadImgPath = $(this).attr('uploadImgPath');
                var existImgPath = $(this).attr('existImgPath');
                // 要replaceAll  下面的则不需要 尬
                var divID = $(this).attr('uploadImgPath').replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.ajax({
                    type: 'post',
                    dataType: 'json',
                    url: "http://localhost:8080/pic/picture/ajaxHandleSamePic",
                    data: {'handleMethod':handleMethod,
                            'uploadImgPath':uploadImgPath,
                            'existImgPath':existImgPath},
                    contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
                    success:  function(data) {
                        if(data.status == 'success'){
                            $("#"+divID).remove();
                            success_prompt(data.msg,1500);
                        }else if(data.status == 'fail'){
                            fail_prompt(data.msg,2500);
                        }else {
                            warning_prompt("其他未知错误.....please enjoy debug",2500);
                        }
                    }
                });
            });

            // 批量操作
            $('.myselectAll').on('click', function(){
                var handleMethod = $(this).attr('handleMethod');
                $.ajax({
                    type:'post',
                    contentType : 'application/json;charset=utf-8',
                    url:"http://localhost:8080/pic/picture/ajaxHandleSamePicAll?handleMethod="+handleMethod,
                    data:{},
                    success:function(data) {
                        if(data.status == 'success'){
                            success_prompt(data.msg,2500);
                            $("#main").remove();
                            countDown(3,data.justUploadMsg);
                        }else if(data.status == 'fail'){
                            fail_prompt(data.msg,2500);
                        }else {
                            warning_prompt("其他未知错误.....please enjoy debug",2500);
                        }
                    },
                    dataType:"json"
                });
            });
        });

        var countDown = function (secs,msg){
            if(--secs>0){
                setTimeout("countDown("+secs+")",1000);
            }else{
                if(msg === undefined){
                    $(window).attr("location","pages/picture.jsp");
                }else {
                    $(window).attr("location","uploadDir.jsp");
                }
            }
        }
    </script>

    <%--alert自动消失--%>
    <script type="text/javascript">
        var prompt = function (message, style, time)
        {
            style = (style === undefined) ? 'alert-success' : style;
            time = (time === undefined) ? 1200 : time;
            $('<div>')
                .appendTo('body')
                .addClass('alert ' + style)
                .html(message)
                .show()
                .delay(time)
                .fadeOut();
        };
        var success_prompt = function(message, time)
        {
            prompt(message, 'alert-success', time);
        };

        // 失败提示
        var fail_prompt = function(message, time)
        {
            prompt(message, 'alert-danger', time);
        };

        // 提醒
        var warning_prompt = function(message, time)
        {
            prompt(message, 'alert-warning', time);
        }
        // 信息提示
        var info_prompt = function(message, time)
        {
            prompt(message, 'alert-info', time);
        };
    </script>
    <%--点击显示大图和标题--%>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>

</head>
<body>

<%--完美解决 图片的页面显示问题--%>
<a href="uploadDir.jsp"><h1>回到文件夹上传</h1></a>
<h1 style="display : inline"><a href="picture/page" >  查看所有照片  </a> </h1>
<c:if test="${not empty monthsTreeMapListPic or not empty failedPicturesList}">
<div id = "main">
    <span class="firstSpan"><input class="myselectAll" handleMethod ="saveBoth" type="button" value="保存全部" style="color:green;font-size: larger;width: 100%;"></span>
    <span class="firstSpan"><input class="myselectAll" handleMethod ="deleteBoth" type="button" value="删除全部" style="color:red;font-size: larger;width:100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveExistOnly" type="button" value="只保存全部本地" style="color:navy;font-size: larger;width: 100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveUploadOnly" type="button" value="只保存全部上传" style="color:firebrick;font-size: larger;width: 100%;"></span>

    <div style="width:100%;height:100%;overflow: scroll;">
        <%-- 不重复的照片 --%>
        <c:if test="${not empty monthsTreeMapListPic}">
            <div class="panel-group" id="accordion">
            <c:set var="index" value="0" />
            <c:forEach var="monthTreeMapListPic" items="${monthsTreeMapListPic}">
                <%--月份的div框--%>
                <div class="c2">
                    <c:set var="index" value="${index+1}" />
                    <button type="button" class="btn btn-primary" data-toggle="collapse"
                            data-target="#${monthTreeMapListPic.key}" style="background: #e3e3e3">
                        <h2 style="color: chocolate">${monthTreeMapListPic.key}</h2>
                    </button>

                    <%--最近一个月份的照片不折叠--%>
                    <c:if test="${index.equals(1)}">
                        <div id="${monthTreeMapListPic.key}" class="collapse in">
                            <div class = "zuiOut"  >
                            <c:forEach items="${monthTreeMapListPic.value}" var="picture" >
                                <div class="outdiv" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                        <h3 style="color: red">上传照片:${picture.path}</h3>
                                        <h4 style="color: chocolate">图片尺寸： ${picture.pwidth}*${picture.pheight}</h4>
                                        <h4 style="color: gray">图片大小： ${picture.psize} M</h4>
                                        <span align="center" style="float: left;width: 25%;">
                                        <input class="myselect" type="button" value="保存" style="font-size: larger;width: 100%;text-align:center"
                                             handleMethod ="saveSingle" uploadImgPath = ${picture.path} existImgPath=""></span>
                                        <span align="center" style="float: right;width: 25%;">
                                        <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                                            handleMethod ="deleteSingle" uploadImgPath = ${picture.path} existImgPath=""></span>
                                        <div class="imgdiv">
                                            <a href="picture/before_edit_picture?pid=${picture.pid}">
                                            <img src="${picture.path}">
                                            </a>
                                        </div>
                                </div>
                            </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not index.equals(1)}">
                        <div id="${monthTreeMapListPic.key}" class="collapse in">
                            <c:forEach items="${monthTreeMapListPic.value}" var="picture" >
                                    <div class = "zuiOut" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}" >
                                        <div class="outdiv">
                                            <h3 style="color: red">上传照片:${picture.path}</h3>
                                            <h4 style="color: chocolate">图片尺寸： ${picture.pwidth}*${picture.pheight}</h4>
                                            <h4 style="color: gray">图片大小： ${picture.psize} M</h4>
                                            <span align="center" style="float: left;width: 25%;">
                                            <input class="myselect" type="button" value="保存" style="font-size: larger;width: 100%;text-align:center"
                                                   handleMethod ="saveSingle" uploadImgPath = ${picture.path}></span>
                                                <span align="center" style="float: right;width: 25%;">
                                            <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                                               handleMethod ="deleteSingle" uploadImgPath = ${picture.path}></span>
                                            <div class="imgdiv">
                                                <a href="picture/before_edit_picture?pid=${picture.pid}">
                                                    <img src="${picture.path}">
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <%--清除div的格式 以便于每月的图片另起一行显示--%>
                    <div style="clear: both"></div>
                </div>
            </c:forEach>
        </div>
        </c:if>
        <%-- 重复照片的显示 --%>
        <c:if test="${not empty failedPicturesList}">
         <div class="panel-group" id="accordion">

            <button type="button" class="btn btn-primary" data-toggle="collapse"
                    data-target="#可能重复的照片" style="background: #e3e3e3">
                <h2 style="color: chocolate">可能重复的照片</h2>
            </button>
            <div id="可能重复的照片" class="collapse in">

                <c:forEach items="${failedPicturesList}" var="picture" >
                    <div class="zuiOut"  id = "${picture.uploadPicture.path.replace('\\', '').replace('_', '').replace('.', '')}" >
                        <h1 style="color: red">${picture.failedMsg}</h1>
                        <span align="right" style="float: left;width: 49%">
                        <input class="myselect" value="都保留" type="button" style="color:green;font-size: larger;width: 100%;text-align:right"
                               handleMethod ="saveBoth" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                        <span align="left" style="float: right;width: 49%">
                        <input class="myselect" value="都删除" type="button" style="color: red;font-size: larger;width: 100%;text-align:left"
                               handleMethod ="deleteBoth" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>


                        <div class="outdiv" style="float: left">
                                <%-- 本地图片 --%>
                            <h4 style="color: red">本地图片：${picture.existPicture.pname}</h4>
                            <h4 style="color: chocolate">图片尺寸： ${picture.existPicture.pwidth}*${picture.existPicture.pheight}</h4>
                            <h4 style="color: gray">图片大小： ${picture.existPicture.psize} M</h4>
                            <span align="center" style="float: left">
                                <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                                 handleMethod ="saveExistOnly" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                                    <a href="picture/before_edit_picture?pid=${picture.pid}">
                            <div class="imgdiv">
                                <img src="${picture.existPicture.path}">
                            </div>
                            </a>
                        </div>

                        <div class="outdiv" style="float: right">
                                 <%-- 上传图片 --%>
                             <h4 style="color: seagreen">上传图片：${picture.uploadPicture.pname}</h4>
                             <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                             <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                             <span align="center" style="float: left">
                                <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                                   handleMethod ="saveUploadOnly" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                         <a href="picture/before_edit_picture?pid=${picture.pid}">
                            <div class="imgdiv">
                                <img src="${picture.uploadPicture.path}">
                            </div>
                                </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
                <%--清除div的格式 以便于每月的图片另起一行显示--%>
           <%-- <div style="clear: both"></div>--%>
        </div>
        </c:if>
    </div>
</div>
</c:if>
</body>
</html>
