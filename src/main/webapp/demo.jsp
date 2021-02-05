<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>

</head>
<body>
<h1>文件上传</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    图  像1：<input type="file" name="img" value="pppp"/><br/>
    <%--图  像2：<input type="file" name="img" value="pppp"/><br/>--%>
    <%--图  像3：<input type="file" name="img" value="pppp"/><br/>--%>
    <input type="submit" value="上传">
</form>

</body>
</html>