<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/3
  Time: 15:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>
    <title>Title</title>
</head>
<body>
    <c:forEach begin="1" end="10" var="s">

        <div id = "picArea1" class="picdiv"  style="width:100px;height:100px;border: 1px solid red;padding-left: 0px;padding-right: 0px"
             ondragover="allowDrop(event)"
             ondrop="drop(event)" >
            <span>${s}.拖到此处</span>
        </div>

       <%-- <div id = "picArea2" class="picdiv"  style="width:100px;height:100px;border: 1px solid red;padding-left: 0px;padding-right: 0px"
             ondragover="allowDrop(event)"
             ondrop="drop(event)" >
            <span>2.拖到此处</span>
        </div>--%>
    </c:forEach>
</body>

<script>

</script>
</html>
