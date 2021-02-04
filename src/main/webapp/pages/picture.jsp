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

    <%--点击显示大图和标题--%>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>

    <script type="text/javascript">
        var data = {
            "img/f2/gofree.jpg":"p1",
            "img/f2/k.jpg":"p2"
        };
        $(function(){
            $.each(data,function(key,value){
                //初始化最后一个div为隐藏
                // $("div").big_img_div().hide();
                $("#big_img_div").hide();
                //创建小图的节点
                var smallPath = $("<img src='" + key + "' />").
                css({"margin":"5px","padding":"2px","border":"1px solid #000","height":"300px"});
                //设置大图地址和名称
                bigImgPath = smallPath.attr("bigMapPath",key);//"img/f2/gofree.jpg"
                bigImgName = smallPath.attr("bigMapName",value);//"美人1"
                $("#small_img_div").append(smallPath);

                //小图上添加事件
                smallPath.click(function(){
                    //最后一个div淡入效果
                    $("#big_img_div").fadeIn("fast");
                    //获取大图地址
                    $("#show").attr("src",$(this).attr("bigMapPath"));
                    //获取大图名称并设置样式
                    $("#imgTitle").val($(this).attr("bigMapName")).
                    css({"background":"#ebf1de","padding":"10px","margin-bottom":"10px"});
                });

                // 点击图片 显示或隐藏图片  若点击  文本输入框  则进行图片名称的修改  尬
                // 修改完图片名称后 点击图片区域  关闭大图片 继续显示小图
                $("#show").click(function(){
                    $("#big_img_div").fadeOut("fast");
                });
            });
        });
    </script>
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

                           <%-- <c:forEach items="${item.value}" var="picture" >
                                <div class="c1">
                                    &lt;%&ndash;现实照片拍摄的时间&ndash;%&gt;
                                    <h2 align="center" style="color: seagreen">${picture.pcreatime}</h2>　
                                    <img src="${picture.path}" height="300px" >
                                </div>
                            </c:forEach>--%>
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
    <%--<%@include file="/pages/page_nav.jsp"%>--%>


    <%--显示照片的大图和标题--%>



    <%--显示小图--%>
    <div ></div>

    <%--显示大图--%>
    <div id="big_img_div">
        <div class="BigInput" >
            <input id="imgTitle" value="">
        </div>
        <div class="BigImg" >
            <img id="show" src=""/>
        </div>
    </div>

</div>





</div>

</body>
</html>
