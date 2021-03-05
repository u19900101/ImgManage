<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>iframe</title>
    <%--<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>--%>
    <style>
        body{background: #C2FFB3;}
        .item-list{
            list-style: none;
            padding:0;
        }
        .item-list li{
            line-height: 50px;
            width:50px;
            background: #FFDECF;
            text-align: center;
            margin-top: 10px;
            border: 2px solid #525252;
            cursor: pointer;
        }
    </style>
</head>
<body>
<span>这里是iframe内部啦，拖拽一下试试看</span>
<ul class="item-list" id="tree1">
    <li draggable="true">1</li>
</ul>
<div id="tree2" ></div>

<script>
    var data = [
        {
            id: 1,
            name: 'node1',
        },
        {
            id: 2,
            name: 'node2',
        }
    ];
    $(function() {
        onLoad();
        function onLoad() {
            // var $tree =
            $('#tree2').tree({
                data: data,
                dragAndDrop: true,
                // The option autoOpen is set to 0 to open the first level of nodes.
                autoOpen: true,
                closedIcon: $('<i class="fa fa-arrow-circle-right"></i>'),
                openedIcon: $('<i class="fa fa-arrow-circle-down"></i>'),
                onDragMove: handleMove,
                onDragStop: handleStop
            });
        };
        function handleMove(node, e) {

            console.log("开始拖拽");
            window.isCrossIFrameDragging = true;
            window.draggingItem = this;
       /*     var dt = e.originalEvent.dataTransfer;
            dt.setData('Text','cross_iframe_drag_'+$(this).text());
            dt.effectAllowed = 'move';
            window.isCrossIFrameDragging = true;
            window.draggingItem = this;*/

        };
        function handleStop(node, e) {
            console.log("拖拽结束");
            console.log(node, e);
            // window.isCrossIFrameDragging = false;
        };


      /*  window.removeDraggingItem = function(){
            $(window.draggingItem).animate({height:0,opacity:0},1000,function(){
                $(this).remove();
            });
            window.draggingItem = null;
        };*/

    });
</script>


<script>
    $(function() {
        $("#tree1").find("li").on("dragstart",function(ev){
            var dt = ev.originalEvent.dataTransfer;
            dt.setData('Text','cross_iframe_drag_'+$(this).text());
            dt.effectAllowed = 'move';
            window.isCrossIFrameDragging = true;
            window.draggingItem = this;
            console.log("开始拖拽",ev);
        }).on("dragend",function(ev){
            console.log("拖拽结束");
            window.isCrossIFrameDragging = false;
        });
        window.removeDraggingItem = function(){
            $(window.draggingItem).animate({height:0,opacity:0},1000,function(){
                $(this).remove();
            });
            window.draggingItem = null;
        };
    });
</script>
</body>
</html>

