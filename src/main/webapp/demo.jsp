<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/pages/head.jsp"></jsp:include>
<html>
<head>

</head>
<body>
<h1>文件上传</h1>
<h1 style="color: lightgreen">${succeed}</h1>
<h1 style="color: red">${failed}</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <%--图  像2：<input type="file" name="img" value="pppp"/><br/>--%>
    <%--图  像3：<input type="file" name="img" value="pppp"/><br/>--%>
    <input type="submit" value="上传">
</form>

</body>
</html>