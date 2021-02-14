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
        /*月份的大框*/
        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

        .imgDiv{
            display:flex;
            align-items:center;
            justify-content:center;
        }
    </style>
    <%--点击显示大图和标题--%>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
    <script type="text/javascript">
        $(function() {
            $('.myselect').on('click', function () {
                var existImgPath = $(this).attr('existImgPath');
                // 要replaceAll  下面的则不需要 尬
                var divID = $(this).attr('existImgPath').replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxDeletePic",
                    "existImgPath=" + existImgPath,
                    function (data) {
                        if (data.status == 'success') {
                            $("#" + divID).remove();
                            success_prompt(data.msg, 1500);
                        } else if (data.status == 'fail') {
                            fail_prompt(data.msg, 2500);
                        } else {
                            warning_prompt("其他未知错误.....please enjoy debug", 2500);
                        }
                    },
                    "json"
                );
            });
        });

    </script>
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
            font-size: xx-large;
        }

        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
            font-size: xx-large;
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
                $.post(
                    "http://localhost:8080/pic/picture/ajaxHandleSamePic",
                    "handleMethod="+handleMethod+"&uploadImgPath="+uploadImgPath+"&existImgPath="+existImgPath,
                    function(data) {
                        if(data.status == 'success'){
                            $("#"+divID).remove();
                            success_prompt(data.msg,1500);
                        }else if(data.status == 'fail'){
                            fail_prompt(data.msg,2500);
                        }else {
                            warning_prompt("其他未知错误.....please enjoy debug",2500);
                        }
                    },
                    "json"
                );
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
                            countDown(3);

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

        function countDown(secs){
            if(--secs>0){
                setTimeout("countDown("+secs+")",1000);
            }else{
                alert(${not empty justUploadMsg});
                if(${not empty justUploadMsg}){
                    $(window).attr("location","picture/showUploadInfo?page=picture");
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
<c:if test="${not empty justUploadMsg}">
    <h1>${justUploadMsg}</h1>
</c:if>
<h1 style="display : inline"><a href="picture/page" >  查看所有照片  </a> </h1>
<h1 style="display : inline"><a href="uploadDir.jsp" >  继续上传照片  </a> </h1>
<div style="width:100%;height:100%;overflow: scroll;">
    <div class="panel-group" id="accordion">
        <c:set var="index" value="0" />
        <c:forEach var="item" items="${monthsTreeMapListPic}">
            <%--月份的div框--%>
            <div class="c2">
                <c:set var="index" value="${index+1}" />
                <button type="button" class="btn btn-primary" data-toggle="collapse"
                        data-target="#${item.key}" style="background: #e3e3e3">
                    <h2 style="color: chocolate">${item.key}</h2>
                </button>

                <%--最近一个月份的照片不折叠--%>
                <c:if test="${index.equals(1)}">
                    <div id="${item.key}" class="collapse in">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <%--现实照片拍摄的时间--%>
                                <c:if test="${not empty picture.pcreatime}">
                                    <h2 align="center" style="color: seagreen">${picture.pcreatime}</h2>　
                                </c:if>
                                <div class="imgDiv">
                                    <a href="picture/before_edit_picture?pid=${picture.pid}">
                                        <img src="${picture.path}" height="300px" >
                                    </a>
                                </div>
                                <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                                       existImgPath = ${picture.path}>

                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not index.equals(1)}">
                    <div id="${item.key}" class="collapse">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                <c:if test="${not empty picture.pcreatime}">
                                    <h3 align="center" style="color: seagreen">${picture.pcreatime}</h3>　
                                </c:if>
                                <div class="imgDiv">
                                    <a href="picture/before_edit_picture?pid=${picture.pid}">
                                        <img src="${picture.path}" height="300px" >
                                    </a>
                                </div>
                                <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                                       existImgPath = ${picture.path}>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <%--<div class="panel panel-default">
                    &lt;%&ndash;折叠月份的标题&ndash;%&gt;
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion"
                               href="#${item.key}">
                                &lt;%&ndash;拍摄时间&ndash;%&gt;
                                <h2 style="color: chocolate">${item.key}</h2>
                            </a>
                        </h4>
                    </div>
                    &lt;%&ndash;折叠月度照片&ndash;%&gt;
                    <div id="${item.key}" class="panel-collapse collapse">
                        <div class="panel-body">

                            <c:forEach items="${item.value}" var="picture" >
                                <div class="c1">
                                    &lt;%&ndash;现实照片拍摄的时间&ndash;%&gt;
                                    <h2 align="center" style="color: seagreen">${picture.pcreatime}</h2>　

                                        <a href="picture/before_edit_picture?pid=${picture.pid}">
                                            <img src="${picture.path}" height="300px" >
                                        </a>

                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>--%>
                <%--清除div的格式 以便于每月的图片另起一行显示--%>
                <div style="clear: both"></div>
            </div>
        </c:forEach>
    </div>
</div>

</div>

</body>
</html>
