<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
    <script type="text/javascript">
        var data = {
            "img/f2/gofree.jpg":["img/f2/gofree.jpg","p1"],
            "img/f2/k.jpg":["img/f2/k.jpg","p2"]
        };
        $(function(){
            $.each(data,function(key,value){
                //初始化最后一个div为隐藏
                $("div").last().hide();
                //创建小图的节点
                var smallPath = $("<img src='" + key + "' />").
                css({"margin":"5px","padding":"2px","border":"1px solid #000","height":"300px"});
                //设置大图地址和名称
                bigImgPath = smallPath.attr("bigMapPath",value[0]);//"img/f2/gofree.jpg"
                bigImgName = smallPath.attr("bigMapName",value[1]);//"美人1"
                $("div").first().append(smallPath);

                //小图上添加事件
                smallPath.click(function(){
                    //最后一个div淡入效果
                    $("div").last().fadeIn("fast");
                    //获取大图地址
                    $("#show").attr("src",$(this).attr("bigMapPath"));
                    //获取大图名称并设置样式
                    $("#imgTitle").val($(this).attr("bigMapName")).
                    css({"background":"#ebf1de","padding":"10px","margin-bottom":"10px"});
                });

                // 点击图片 显示或隐藏图片  若点击  文本输入框  则进行图片名称的修改  尬
                // 修改完图片名称后 点击图片区域  关闭大图片 继续显示小图
                $("#show").click(function(){
                    $("div").last().fadeOut("fast");
                });
                /* smallPath.mouseleave(function(){
                     $("div").last().fadeOut("fast");
                 });*/
            });
        });
    </script>
</head>
<body>

<%--显示小图--%>
<div style="position: absolute;"></div>

<%--显示大图--%>
<div style="position: relative;margin: auto;border: 2px solid red;
    top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	width: 1000px;
	height: 1000px;">
    <%--<h1 id="imgTitle"></h1>--%>
    <input align="center" id="imgTitle" value="" ><br/>
    <img align="center" id="show" src="" height="800"/>
</div>

</html>
