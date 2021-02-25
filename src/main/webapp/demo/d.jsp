<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/23
  Time: 16:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/pages/head.jsp"%>
    <!-- Required Stylesheets -->
    <%-- 这个js 还必须在当前页面才能引入--%>
    <%--<script src="static/script/bootstrap-treeview.js"></script>--%>

</head>
<body>
<div id ='tree' style="width: 30%;float: left"></div>

</body>

<script>
    var defaultData = [
                {
                    text: '一级标签',
                    href: '#',
                    tags: ['4'],
                    nodes: [
                        {
                            text: '二级标签',
                            href: 'https://google.com',
                            tags: ['2344'],
                            // image: "something.png",

                            nodes: [
                                {
                                    nodeId:"kkk",
                                    text: '我是kkk三级标签',
                                    href: 'https://google.com',
                                    icon:  "glyphicon glyphicon-user",
                                    tags: ['100000']
                                },
                                {
                                    text: '待开发功能',
                                    href: '#grandchild2',
                                    tags: ['0']
                                }
                            ]
                        },
                        {
                            text: 'Child 2',
                            href: '#child2',
                            tags: ['0']
                        }
                    ],
                }];

    $('#tree').treeview({
            color: "#000000",
            backColor: "#FFFFFF",
            // enableLinks: true,
            expandIcon: "glyphicon glyphicon-chevron-right",
            collapseIcon: "glyphicon glyphicon-chevron-down",
            nodeIcon: "glyphicon glyphicon-bookmark",
            showTags: true,
            data: defaultData,
            // levels: 2,
            highlightSelected:false,
            // onhoverColor:'#bce8f5', //鼠标 悬浮时的颜色
            // selectedIcon:"glyphicon glyphicon-stop", //选中时的按钮
            // showBorder:true,
            // showCheckbox:true,  // 单选框

            // tooltip:"提示信息",
        });

    // $('#tree').treeview('checkAll', { silent: true });
    // $('#tree').treeview('collapseAll', { silent: true });
    // $('#tree').treeview('expandAll', { levels: 2, silent: true });
    // $('#tree').treeview('disableAll', { silent: true });
    // $('#tree').treeview('disableNode', [ 3, { silent: true } ]);


    // $('#tree').treeview('remove');  // 移除所有
    // var nodeInfo = $('#tree').treeview('revealNode', [ 3, { silent: true } ]);
    // alert(JSON.stringify(nodeInfo));

    // 搜索 text 内容模糊匹配的 所有 node 结果 红色 高亮  //新版本中有点bug

    var resNodes = $('#tree').treeview('search', [ 'c', {
        ignoreCase: true,     // case insensitive
        exactMatch: false,    // like or equals
        revealResults: true,  // reveal matching nodes
    }]);
    alert(resNodes.length);
    // $('#tree').treeview('findNodes', ['一', '一']);
    // $('#tree').treeview('selectNode', [ 0, { silent: true } ]); // 选中 指定 id的节点
   /* $('#tree').on('nodeSelected', function(event, data) { // 触发选中事件
        var newNode =  {
            text: '新增的标签',
            href: '#',
            tags: ['0']
        };
        var tempNode =  $('#tree').treeview('getSelected');
        /!*  If parentNode evaluates to false, node will be added to root
       If index evaluates to false, node will be appended to the nodes *!/
        var parentNode = false;
        // 0 代表 一级标签 在开头
        // 1 或者其他  代表 二级标签
        $('#tree').treeview('addNode', [ newNode, tempNode, false, { silent: true } ]);

        // 在节点之后添加 新节点
        // $('#tree').treeview('addNodeAfter', [ newNode, tempNode, { silent: true } ]);
        // 更新节点
        // $('#tree').treeview('updateNode', [ tempNode, newNode, { silent: true } ]);
        // 移除节点
        // $('#tree').treeview('removeNode', [ tempNode, { silent: true } ]);
    });*/


    // $('#tree').treeview('addNode', [ nodes2, parentNode, 1, { silent: true } ]);

    // $('#tree').treeview('disableNode', [ nodes2, { silent: true, keepState: true } ]);


    // var node = false;
    // $('#tree').treeview('addNodeAfter', [ nodes, node, { silent: true } ]);



</script>
</html>
