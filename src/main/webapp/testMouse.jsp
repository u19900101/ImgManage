<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/14
  Time: 20:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".myselect").mouseenter(function(){
                // alert("kkk");
                $(this).append("<input id = \"kkk\"  type=\"button\" value=\"删除\" style=\"font-size: larger;width: 100%;text-align:center\"handleMethod =\"deleteSingle\" uploadImgPath = ${picture.path}></span>");
            });
            $(".myselect").mouseleave(function(){
                $("#kkk").remove();
            });
        });
    </script>
</head>
<body>
<div >
    <div id="k1" class="myselect" style="height: 300px;width: 300px">
        <a href="picture/before_edit_picture?pid=${picture.pid}">
            <img src="img\2021\02\13\mmexport1604377695012.jpg" height="300px" >
        </a>

    </div>

    <div id="k2" class="myselect" style="height: 300px;width: 300px">
        <a href="picture/before_edit_picture?pid=${picture.pid}">
            <img src="img\2021\02\13\mmexport1604377695012.jpg" height="300px" >
        </a>
    </div>

    <div id="k3" class="myselect" style="height: 300px;width: 300px">
        <a href="picture/before_edit_picture?pid=${picture.pid}">
            <img src="img\2021\02\13\mmexport1604377695012.jpg" height="300px" >
        </a>
    </div>

    <div id="k4" class="myselect" style="height: 300px;width: 300px">
        <a href="picture/before_edit_picture?pid=${picture.pid}">
            <img src="img\2021\02\13\mmexport1604377695012.jpg" height="300px" >
        </a>
    </div>
</div>

</body>
</html>
