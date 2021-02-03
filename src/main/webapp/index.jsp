<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
        .c1{
            float: left;
            border: 1px solid red;
            width: 100px;
            height: 100px;
        }

        .c2{
            float: left;
            border: 1px solid magenta;
            width: 200px;
            height: 100px;
        }
    </style>
</head>
<body>
<h2>Hello World!</h2>

<%--<h1><a href="picture/init">add pic info</a> </h1>--%>
<h1><a href="picture/page">add pic info</a> </h1>

<%----%>
<div class="c1">第1个div</div>
<div class="c2">第2个div</div>
<div class="c2">第3个div</div>
<div class="c1">第4个div</div>
<%--<%@include file="/pages/page_nav.jsp"%>--%>

</body>
</html>
