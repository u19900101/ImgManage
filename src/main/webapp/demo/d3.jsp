<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>Bootstrap 实例 - 警告框（Alert）插件 alert() 方法</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>


<input id = "input" value="jingjing">
<button id="subInput" class="btn success ">提交</button>
<div id = "res">结果：</div>
<script>
$(function () {
    var addLabel = function (labelName2){
        var html ='<div id="myAlert" class="alert alert-success" style="width:fit-content;">' +
            '<span class="close" data-dismiss="alert">&times; </span>' +
            '<strong id = '+labelName2+'>'
            + labelName2 + '</strong></div>';
        $("#res").append(html);
    };
    // 移除添加的标签时获取 标签值
    $('body').on('click','.close',function(){
        alert("警告消息框被关闭--"+$(this).next().text());
    });

    $("#subInput").on("click",function () {
        var name = $("#input").val();
        addLabel(name);
    });

});

</script>

</body>
</html>