<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html style="opacity: 1;">
</head>
<body>
<c:forEach begin="1" end="2" var="i">
    <div style="border: 1px solid red;width: 200px;height: 200px;float: left" id="son0${i}" class="picdiv" picpath = "/kkk/k.jpg">iframe-2</div>
    <div style="border: 1px solid red;width: 200px;height: 200px;float: left" id="son1${i}" class="picdiv" picpath = "/kkk/k.jpg">iframe-3</div>
    <div style="border: 1px solid red;width: 200px;height: 200px;float: left" id="son2${i}" class="picdiv" picpath = "/kkk/k.jpg">iframe-4</div>
    <div style="border: 1px solid red;width: 200px;height: 200px;float: left" id="son3${i}"  class="picdiv" picpath = "/kkk/k.jpg">iframe-5</div>
    <div style="border: 1px solid red;width: 200px;height: 200px;float: left" id="son4${i}"  class="picdiv" picpath = "/kkk/k.jpg">iframe-6</div>
</c:forEach>


</body>
</html>
