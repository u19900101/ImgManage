<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <meta charset="utf-8" />
    <title>Bootstrap TreeView Drag And Drop</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>
</head>
<body>
<div class="container-fluid">
    <div id="tree"></div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        var dataSource = [
            {   id:"11",
                text: "Parent 1",
                href:"kkk1",
                children: [
                    {
                        id:"22",
                        text: "Child 1",
                        href:"kkk2",
                    },
                    {
                        id:"33",
                        text: "Child 2",
                        href:"kkk3",
                    }
                ]
            },
        ];
        var tree = $('#tree').tree({
            primaryKey: 'id',
            uiLibrary: 'bootstrap',
            dataSource: dataSource,
            dragAndDrop: true,
            select: function (e, node, id,href) {
                alert('select href  ' + href);
            }
        });
        tree.on('nodeDrop', function (e, id, parentId, orderNumber) {

            var params = { id: id, parentId: parentId, orderNumber: orderNumber };
               /* $.ajax({ url: '/Locations/ChangeNodePosition', data: params, method: 'POST' })
                    .fail(function () {
                        alert('Failed to save.');
                    });*/
        });
    });
</script>
</body>
</html>