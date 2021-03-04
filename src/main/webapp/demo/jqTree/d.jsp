<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        #simpleList {
            flex: 1;
        }
    </style>
</head>

<body>

<div class="container-fluid" >
    <div class="row">
        <div class="col-md-3" style="border: 1px solid greenyellow">

            <div id="tree1" ></div>
            <c:forEach begin="1" end="2" var="s">
                <div id = "picArea1" class="picdiv"  style="width:100px;height:100px;border: 1px solid red;padding-left: 0px;padding-right: 0px"
                     ondragover="allowDrop(event)"
                     ondrop="drop(event)" >
                    <span>本页面-   ${s}</span>
                </div>
            </c:forEach>
        </div>
        <div class="col-md-9 pull-right" style="border: 1px solid red">
    <%--         <iframe src="demo/jqTree/ddiv.jsp" name='main' id="iframepage" frameborder="0" width="100%" height="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe>--%>
        <div id = "picArea" class="picdiv"  style="width:100px;height:100px;border: 1px solid red;padding-left: 0px;padding-right: 0px">
            结果：
        </div>
        </div> 
    </div>
</div>

</body>
<script>
    function allowDrop(ev)
    {
        ev.preventDefault();
    }

    function drag(ev,id)
    {
        // ev.dataTransfer.setData("label",id);
    }

    function drop(ev)
    {
        ev.preventDefault();
        // var label=ev.dataTransfer.getData("label");
        $("#picArea").append("label");
        //    写进数据库
    }
</script>

<script>
    var data = [
        {   id :1,
            name: 'node1a',
            href: "herf",
            children: [
                { id :2,name: 'child1' },
                { id :3,name: 'child2' }
            ]
        },
        {
            id :4,name: 'node2',
            children: [
                { id :5,name: 'child3a' }
            ]
        }
    ];
    $(function() {
        onLoad();
        function onLoad() {
            // alert("kkk");
            // var $tree =
            $('#tree1').tree({
                data: data,
                dragAndDrop: true,
                // The option autoOpen is set to 0 to open the first level of nodes.
                autoOpen: true,
                closedIcon: $('<i class="fa fa-arrow-circle-right"></i>'),
                openedIcon: $('<i class="fa fa-arrow-circle-down"></i>'),
                // onDragMove: handleMove,
                // onDragStop: handleStop
            });
        };

        /*var lastClickNode = [{ id :"-1",name: '' }];
        var count = 10;

        $tree.on( 'tree.click', function(e) {
            // Disable single selection
            e.preventDefault();
            var selected_node = e.node;
            if (selected_node.id === undefined) {
                console.warn('The multiple selection functions require that nodes have an id');
            }
            if(lastClickNode.id != selected_node.id){
                var nodes = $('#tree1').tree('getSelectedNodes');
                if(nodes.length>0){
                    for (var i = 0; i < nodes.length; i++) {
                        $tree.tree('removeFromSelection', nodes[i]);
                    }
                }
                $tree.tree('addToSelection', selected_node);
            }
            lastClickNode = selected_node;

            // var newNode = {
            //     name: 'new_node_'+count++,
            //     id: count++,
            // };
            // var parent_node = selected_node;
            // addNode(parent_node,newNode);
            // $tree.tree('removeNode', selected_node);
            // $tree.tree('updateNode', selected_node, 'new name');

            /!*var node = $('#tree1').tree(
                'getNodeByCallback',
                function(node) {
                    if (node.name.indexOf('a')) {
                        // Node is found; return true
                        alert("模糊找到");
                        return true;
                    }
                    else {
                        // Node not found; continue searching
                        return false;
                    }
                }
            );*!/
         /!*   var tree_data = $('#tree1').tree('getTree');
            alert(tree_data.name);
            var data = tree_data.getData(true);
            alert(data.length);*!/
            // var $tree = $('#tree1');
            // searchNode("a");
        });
        function handleMove(node, event) {
            // alert("handleMove");
        };

        function handleStop(node, e) {
            // 遍历所有的div 查看是否 拖拽到了该div
            for (var i = 0; i < $(".picdiv").length; i++) {
                var classTmp = '.picdiv:eq(' + i + ')';
                if(e.clientX >  $(classTmp).position().left &&
                    e.clientX <  $(classTmp).position().left +
                    $(classTmp).width() &&
                    e.clientY >  $(classTmp).position().top &&
                    e.clientY <  $(classTmp).position().top +$(classTmp).height()
                ) {
                    $(classTmp).append(node.name);
                    return;
                }

            }

        }
        var searchNode = function (search_term) {
            var tree = $tree.tree('getTree');
            tree.iterate(
                function(node) {
                    if (node.name.indexOf(search_term) == -1) {
                        // Not found, continue searching
                        // alert("开始查找： "+node.name);
                        return true;
                    }
                    else {
                        // Found. Select node. Stop searching.
                        $tree.tree('addToSelection', node);
                        // alert("找到了，添加选中： "+node.name)
                        return false
                    }
                }
            );
        };

        var addNode = function(parent_node,newNode){
            $tree.tree(
                'appendNode',
                newNode,
                parent_node
            );
        };*/
        // alert( $("#tree1").find("li").length);
    });
</script>


<script>



    /*var frameHTML ="some content";

    var $iframe = $("#iframepage");
    $iframe.ready(function() {
        $iframe.contents().find("body").html(frameHTML);
    });
    /!**
     * End of iFrame code
     *!/
    $(function() {
        $("#draggable").draggable({
            connectToSortable: $iframe.contents().find("#sortable").sortable({
                items:"> div",
                revert: true,
            }),
            helper:"clone",
            iframeFix: true,
            helper: function(event) {
                return"I move this";
            },
            revert:"invalid"
        });
        $iframe.contents().find("#sortable").disableSelection();
    });*/
</script>
</html>