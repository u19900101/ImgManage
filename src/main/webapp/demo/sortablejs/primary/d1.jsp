<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/4
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html lang="en">
<head>
    <script>
        $(function() {
            $("#draggable").draggable({scroll: true, scrollSensitivity: 100});
            $("#droppable").droppable({
                drop: function (event, ui) {
                    console.log("main-kkkk");
                    $(this)
                        .addClass("ui-state-highlight")
                        .find("p")
                        .html("Dropped!");
                },
            });
            /* $( "#draggable" ).draggable({
                 stop: function( e, ui ) {
                     var iframe = $("#iframe");
                     $(".picdiv",window.frames[0].document).each(function(i){

                         var x_start = $(iframe).position().left+$(this).position().left;
                         var x_end = $(iframe).position().left+$(this).position().left + $(this).width();
                         var y_start = $(iframe).position().top+$(this).position().top;
                         var y_end = $(iframe).position().top+$(this).position().top + $(this).height();

                         if(e.clientX >  x_start &&
                             e.clientX <  x_end  &&
                             e.clientY >  y_start &&
                             e.clientY <  y_end
                         ) {
                             console.log("x 方向区域： ",x_start,x_end);
                             console.log("y 方向区域： ",y_start,y_end);
                             // 122 53
                             console.log("落点： "+e.clientX,e.clientY);
                             $(this).append('mjjjjj');
                             return;
                         }
                     });
                     console.log("停下来鸟",ui.position,ui.offset);
                 }
             });*/
        });
    </script>

</head>
<body>
<div id="draggable" style="border: 1px solid red;width: 30px;height: 30px;">
    <p>拖拽</p>
</div>

<div id="droppable" style="border: 1px solid yellow;width: 100px;height: 100px;float: left">
    <p>请放置在这里！</p>
</div>

<div style="width: 70%;float: right">
    <iframe id="iframe" src="demo/sortablejs/primary/d2.jsp" frameborder="0" width="100%" height="100%"  marginwidth="0"></iframe>
</div>
<%--<header class="container-fluid" >
    <div class="row">
        <div class="col-md-3" style="border: 1px solid greenyellow">
            <div id="draggable" style="float: left;border: 1px solid red">
                Drag me
            </div>
        </div>
        <div class="col-md-9 pull-right" >
            <div>
                <iframe id="iframe" src="demo/sortablejs/primary/d2.jsp" frameborder="0" width="100%" height="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
            </div>

        </div> 
    </div>
</header>--%>
</body>



</body>
</html>
