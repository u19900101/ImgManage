
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>
   <script>
        $(function () {
            var addLabel = function (newlabelName){
                alert("开始添加标签"+ newlabelName);
                var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                    '<span class="close" data-dismiss="alert">&times; </span>' +
                    '<strong id = '+newlabelName+'>'
                    + newlabelName + '</strong></div>';
                // var html = '<span>kkk</span>';
                $("#picTags_index").append(html);
            };
            addLabel("kkk");
        });


    </script>
</head>

<body>

<div class="alert alert-warning">
    <a href="#" class="close" data-dismiss="alert">
        &times;
    </a>
    <strong>警告！</strong>您的网络连接有问题。
</div>
<div id = "picTags_index">


</div>

</body>
</html>