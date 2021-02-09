<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/9
  Time: 9:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript">
        function browseFolder(path) {
            try {
                var Message = "\u8bf7\u9009\u62e9\u6587\u4ef6\u5939"; //选择框提示信息
                var Shell = new ActiveXObject("Shell.Application");
                var Folder = Shell.BrowseForFolder(0, Message, 64, 17); //起始目录为：我的电脑
                //var Folder = Shell.BrowseForFolder(0,Message,0); //起始目录为：桌面
                if (Folder != null) {
                    Folder = Folder.items(); // 返回 FolderItems 对象
                    Folder = Folder.item(); // 返回 Folderitem 对象
                    Folder = Folder.Path; // 返回路径
                    if (Folder.charAt(Folder.length - 1) != "") {
                        Folder = Folder + "";
                    }
                    document.getElementById(path).value = Folder;
                    return Folder;
                }
            }
            catch (e) {
                alert(e.message);
            }
        }
    </script>
</head>
<body>
<%--<form action="picture/uploadDir" enctype="multipart/form-data" method="post">
    &lt;%&ndash;accept="image/*" ，表示提交的文件只能为图片，若没有添加该内容，则图片、文档等类型的文件都可以提交&ndash;%&gt;
    图  像 ：<input type="file" name="img" value="pppp" webkitdirectory/><br/>
    <input type="submit" value="上传">
</form>--%>

<tr>
    <td>选择导入数据源：</td>
    <td><input id="path" type="text" name="path" size="30"></td>
    <td><input type=button value="选择" onclick="browseFolder('path')"></td>
</tr>

</body>
</html>
