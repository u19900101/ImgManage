<html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<head>

</head>
<body>
<h1>map is :</h1>${map}<br>
<h1>facePicture is :</h1>
<h3>${facePicture.picId}</h3>
<h3>${facePicture.faceNum}</h3>
<h3>${facePicture.faceIds}</h3>
<h3>${facePicture.locations}</h3>
<h3>${facePicture.landmarks}</h3>

</body>
<script>
    var faceIds =${facePicture.locations};
    for (var i = 0; i < faceIds.length; i++) {
        console.log(faceIds[i][0],faceIds[i][1],faceIds[i][2],faceIds[i][3]);
    }
</script>
</html>