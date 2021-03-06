<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/3
  Time: 21:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
</head>
<body>
<!-- 3 setup a container element -->
<div id="jstree1">
    <span>第 1 棵树：</span>
    <ul class="jstree-open">
        <li>Root node 1
            <ul>
                <li id="child_node_11">Child node 1</li>
                <li id="child_node_12"><a href="http://www.baidu.com " class="jstree-clicked">Child node 2</a></li>
            </ul>
        </li>
        <li class="jstree-open">Root node 2
            <ul >
                <li id="child_node_21" >drag</li>
                <li id="child_node_222"><a>Child node 22</a></li>
            </ul>
        </li>

    </ul>
   <%-- <ul>
        <li data-jstree='{"opened":true,"selected":true}'>Root
            <ul>
                <li data-jstree='{"disabled":true}'>Child</li>
                <li data-jstree='{"icon":"//jstree.com/tree.png"}'>
                    Child</li>
                <li data-jstree='{"icon":"static/jqTree/jqtree-circle.png"}'>
                    Child</li>
                <li data-jstree='{"icon":"glyphicon glyphicon-leaf"}'>
                    Child</li>
            </ul>
        </li>
    </ul>--%>
</div>


<li id="drop" class="jstree-drop">jstree-drop</li>
<li id="drag" class="drag">jstree-drag</li>
<%--<div style="border: 1px solid red;width: 200px;height: 200px;float: left" class="picdiv">iframe-2</div>--%>
<%--<div style="border: 1px solid red;width: 200px;height: 200px;float: left" class="picdiv">iframe-3</div>--%>
<%--<div style="border: 1px solid red;width: 200px;height: 200px;float: left" class="picdiv">iframe-4</div>--%>
<%--<div style="border: 1px solid red;width: 200px;height: 200px;float: left" class="picdiv">iframe-5</div>--%>
<%--<div style="border: 1px solid red;width: 200px;height: 200px;float: left" class="picdiv">iframe-6</div>--%>
<%--<button>demo button</button>--%>
<input id="serach">

<script>
        $('#jstree1').jstree({
            "core" : {
                "multiple" : false,//只进行单选
                "animation" : 0,
                "themes" : {
                    "variant" : "large"
                },
                "check_callback" : true,
                'data' : [
                    { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" ,"icon": "glyphicon glyphicon-leaf" },
                    { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" ,"icon": "glyphicon glyphicon-tag" },
                    { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
                    { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
                ],
            },
            /*'data' : [
                'Simple root node',
                {
                    'text' : 'Root node 2',
                    'state' : {
                        'opened' : true,
                        'selected' : true
                    },
                    'children' : [
                        { 'text' : 'Child 1' },
                        'Child 2'
                    ]
                }
            ],*/

            /*  "checkbox" : {
                  "keep_selected_style" : false
              }, "wholerow",   */
            "plugins" : ["dnd","search", "contextmenu"]
        });
        // 6 create an instance when the DOM is ready

        $(".drag").draggable({
            appendTo: "body",
            containment: "window",
            cursor: "move",
            revert: true,
            helper: "clone",
            scroll: true,
            iframeFix: true, //Core jquery ui params needs for fix iframe bug
            iframeScroll: true
        });
        $("#drop").droppable({
            accept: '*',
            greedy: true,
            drop: function(event, ui) {
                console.log('came in droppable');
                $(this).append(ui.draggable.clone());
                // $('Iframe').trigger('load');
            }
        });


       /* var to = false;
        $('#serach').keyup(function () {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
                var v = $('#serach').val();
                $('#jstree').jstree(true).search(v);
            }, 250);
        });*/

       /* $('#jstree').jstree({
            "core" : {
                "animation" : 0,
                "check_callback" : true,
                "themes" : { "stripes" : true },
                'data' : {
                    'url' : function (node) {
                        return node.id === '#' ?
                            'ajax_demo_roots.json' : 'ajax_demo_children.json';
                    },
                    'data' : function (node) {
                        return { 'id' : node.id };
                    }
                }
            },
            "types" : {
                "#" : {
                    "max_children" : 1,
                    "max_depth" : 4,
                    "valid_children" : ["root"]
                },
                "root" : {
                    "icon" : "/static/3.3.11/assets/images/tree_icon.png",
                    "valid_children" : ["default"]
                },
                "default" : {
                    "valid_children" : ["default","file"]
                },
                "file" : {
                    "icon" : "glyphicon glyphicon-file",
                    "valid_children" : []
                }
            },
            "plugins" : [
                "contextmenu", "dnd", "search",
                "state", "types", "wholerow"
            ]
        });*/
       /* $("li").draggable({
            appendTo: "body",
            containment: "window",
            cursor: "move",
            revert: true,
            helper: "clone",
            scroll: true,
            iframeFix: true, //Core jquery ui params needs for fix iframe bug
            iframeScroll: true
        });*/
</script>



</body>
</html>
