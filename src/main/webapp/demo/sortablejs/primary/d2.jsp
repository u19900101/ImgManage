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
                    console.log("son-kkkk");
                    $(this)
                        .addClass("ui-state-highlight")
                        .find("p")
                        .html("Dropped!");
                },
            });
        });
    </script>

</head>
<body>
<div id="draggable" style="border: 1px solid red;width: 30px;height: 30px;">
    <p>zi - 拖拽</p>
</div>

<div id="droppable" style="border: 1px solid yellow;width: 100px;height: 100px;">
    <p>zi - 放置</p>
</div>
</body>

</body>
</html>
