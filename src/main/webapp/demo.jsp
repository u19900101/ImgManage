<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/pages/head.jsp"></jsp:include>
<html>
<head>

</head>
<body>
<h1>文件上传</h1>
<h1 style="color: lightgreen">${successMsg}</h1>
<h1 style="color: red">${failedMsg}</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <%--图  像2：<input type="file" name="img" value="pppp"/><br/>--%>
    <%--图  像3：<input type="file" name="img" value="pppp"/><br/>--%>
    <input type="submit" value="上传">
</form>

<c:if test="${not empty successPath}">
    <img src="${successPath}" width="600">
</c:if>


<c:if test="${not empty failedImgPath}">
    <h1 style="color: lightgreen">上传的照片：${uploadImgPath}</h1>
    <img src="${uploadImgPath}" width="600"><br/>
    <h1 style="color: red">本地照片:${failedImgPath}</h1><br/>
    <img src="${failedImgPath}" width="600">
</c:if>


</body>
</html>