<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/3
  Time: 20:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
    <style>
        .trash{
            padding: 10px;
            height: 100px;
            background: #BCDAFA;
            border: 2px solid #8C96FF;
            font-size: 60px;
            line-height: 100px;
        }
        .trash.hover{
            background: #FFFFAB;
            border: 2px dashed red;
            color: red;
        }
        #iframe{width:100%;height:450px;}
    </style>
</head>
<body>
<div id="trash" class="trash">我是垃圾箱啦啦啦</div>
<%--<iframe src="./d.jsp" frameborder="0" id="iframe"></iframe>--%>
<iframe src="./son.jsp" frameborder="0" id="iframe"></iframe>
<script type="text/javascript">
    $(function(){
        iframeWindow = $('#iframe')[0].contentWindow;
        $("#trash").on("dragenter",function(ev){
            if(iframeWindow.isCrossIFrameDragging) {
                $(ev.target).addClass("hover").text("别犹豫了赶紧扔了吧");
            }
        })
            .on('dragleave', function(ev) {
                if(iframeWindow.isCrossIFrameDragging) {
                    $(ev.target).removeClass('hover').text("我是垃圾箱啦啦啦");
                }
            })
            .on("dragover",function(ev){
                if(iframeWindow.isCrossIFrameDragging) {
                    ev.preventDefault();
                    ev.originalEvent.dataTransfer.dropEffect = 'move';
                }
            })
            .on("drop",function(ev){
                var df = ev.originalEvent.dataTransfer;
                var data = df.getData("Text");
                if(iframeWindow.isCrossIFrameDragging)  {
                    var id = data.match(/^cross_iframe_drag_([0-9]+)$/)[1];
                    $(ev.target).removeClass('hover').text("丢掉了["+id+"],好样的,继续！");
                    iframeWindow.removeDraggingItem();
                }
            });
    });
</script>
</body>
</html>