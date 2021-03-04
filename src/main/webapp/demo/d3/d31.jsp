<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/4
  Time: 21:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html lang="en">

<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-6" style="height: 100%">
            <div id = "tree1"></div>
            <li id="drag" class="picli" style="border:solid 1px">
                labe1
            </li>
            <span id = "test">点我跳转</span>
            <span>MMMMMMMMM</span>
            <div id="trees">
                <ul class="jqtree_common jqtree-tree jqtree-dnd" role="tree">
                    <li class="jqtree_common jqtree-folder" role="presentation">
                        <div class="jqtree-element jqtree_common" role="presentation">
                            <a class="jqtree-toggler jqtree_common jqtree-toggler-left" role="presentation" aria-hidden="true">
                                <i class="fa fa-arrow-circle-down"></i>
                            </a>
                            <span class="jqtree-title jqtree_common jqtree-title-folder" role="treeitem" aria-level="1" aria-selected="false" aria-expanded="true">
                    node1a
                </span>
                        </div>
                        <ul class="jqtree_common  jqtree-dnd" role="group">
                            <li class="jqtree_common" role="presentation">
                                <div class="jqtree-element jqtree_common" role="presentation">
                        <span class="jqtree-title jqtree_common" role="treeitem" aria-level="2" aria-selected="false" aria-expanded="false">
                            child1
                        </span>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li class="jqtree_common" role="presentation">
                        <div class="jqtree-element jqtree_common" role="presentation">
                            <span class="jqtree-title jqtree_common" role="treeitem" aria-level="1" aria-selected="false" aria-expanded="false">child3a</span></div></li><li class="jqtree_common jqtree-folder" role="presentation"><div class="jqtree-element jqtree_common" role="presentation"><a class="jqtree-toggler jqtree_common jqtree-toggler-left" role="presentation" aria-hidden="true"><i class="fa fa-arrow-circle-down"></i></a><span class="jqtree-title jqtree_common jqtree-title-folder" role="treeitem" aria-level="1" aria-selected="false" aria-expanded="true">node2</span></div><ul class="jqtree_common  jqtree-dnd" role="group"><li class="jqtree_common" role="presentation"><div class="jqtree-element jqtree_common" role="presentation"><span class="jqtree-title jqtree_common" role="treeitem" aria-level="2" aria-selected="false" aria-expanded="false">child2</span></div></li></ul></li></ul></div>
        </div>
        <div class="col-md-6">
            <iframe id="Iframe" src="demo/d3/ifram.jsp" width="100%" height="800"></iframe>
        </div>
    </div>
</div>


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
            var tree = $("#tree1");
// <span class="jqtree-title jqtree_common" role="treeitem" aria-level="2" aria-selected="false" aria-expanded="false">child1</span>

            console.log("firstNode",$("#tree1").find("li").first());
        };
    });

    var $content;
    $("#Iframe").on('load', function() {
        console.log('loaded');
        $content = $(this).contents();
        test($content);
    });
    //Activate droppable zones
    function test(x) {
        $(x).find('body').children('*').droppable({
            accept: '*',
            greedy: true,
            drop: function(event, ui) {
                console.log('came in');
                $(this).append(ui.draggable.clone());
                $('Iframe').trigger('load');
            }
        });
    }

    $("#test").draggable({
        accept: '*',
        greedy: true,
        drop: function(event, ui) {
            console.log('came in');
            $(this).append(ui.draggable.clone());
            // $('Iframe').trigger('load');
        }
    });

    $("#test").on("click",function () {
        console.log("mmmmmm");
    });
    $("span").draggable({
        appendTo: "body",
        containment: "window",
        cursor: "move",
        revert: true,
        helper: "clone",
        scroll: true,
        iframeFix: true, //Core jquery ui params needs for fix iframe bug
        iframeScroll: true
    });

    $("#trees").children('*').draggable({
        appendTo: "body",
        containment: "window",
        cursor: "move",
        revert: true,
        helper: "clone",
        scroll: true,
        iframeFix: true, //Core jquery ui params needs for fix iframe bug
        iframeScroll: true
    });
    $(".picli").draggable({
        appendTo: "body",
        containment: "window",
        cursor: "move",
        revert: true,
        helper: "clone",
        scroll: false,
        iframeFix: true, //Core jquery ui params needs for fix iframe bug
        iframeScroll: true
    });
</script>

</body>

</html>
