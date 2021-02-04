<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>

    <%--少量图片可以有效果  但是按月分就会产生很多问题，作罢--%>
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

<%--显示小图--%>
<div style="position: absolute;" id="small_img_div"></div>

<%--显示大图--%>
<div id="big_img_div">
    <div class="BigInput" >
        <input id="imgTitle" value="">
    </div>
    <div class="BigImg" >
        <img id="show" src=""/>
    </div>
</div>


</html>
