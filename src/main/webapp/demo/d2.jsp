<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()
            + "://"
            + request.getServerName()
            + ":"
            + request.getServerPort()
            + request.getContextPath()
            + "/";
    pageContext.setAttribute("basePath",basePath);
%>

<!--写base标签，永远固定相对路径跳转的结果-->
<base href="<%=basePath%>">
<html>
<head>
    <script type="text/javascript" src="demo/public/bootstrap/jquery-3.1.1.min.js"></script>
    <link rel="stylesheet" href="demo/public/bootstrap/bootstrap.min.css" >
    <script type="text/javascript" src="demo/public/bootstrap/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="demo/public/plugins/bootstrap-treeview/bootstrap-treeview.min.css">
    <script type="text/javascript" src="demo/public/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
    <link rel="stylesheet" type="text/css" href="demo/public/plugins/bootstrap-dialog/bootstrap-dialog.min.css">
    <script type="text/javascript" src="demo/public/plugins/bootstrap-dialog/bootstrap-dialog.min.js"></script>
    <script type="text/javascript" src="static/script/2.6.12.vue.min.js"></script>
    <style>


    </style>
    <script type="text/javascript">

        $(function(){
            onLoad();

            //页面加载
            function onLoad() {
                //渲染树
                $('#left-tree').treeview({
                    data: ${labelTree},
                    levels:2,
                    color: "#000000",
                    backColor: "#FFFFFF",
                    // enableLinks: true,
                    expandIcon: "glyphicon glyphicon-chevron-right",
                    collapseIcon: "glyphicon glyphicon-chevron-down",
                    nodeIcon: "glyphicon glyphicon-bookmark",
                    showTags: true,
                    onNodeSelected:function(event, node){
                        $('#updateName').val(node.text);
                        if($("#isAddLable").is(':checked')){
                            addLabelAjax(node.text);
                        }else {
                            // 点击后  访问后台的路径  后台处理完数据后直接渲染 到指定的页面去
                            document.getElementById("iframepage").src="/pic/" + node.href;
                        }
                    },
                    showCheckbox:false//是否显示多选
                });
            }

            var addLabel = function (newlabelName){
                var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                    '<span class="close" data-dismiss="alert">&times; </span>' +
                    '<strong id = '+newlabelName+'>'
                    + newlabelName + '</strong></div>';
                $("#picTags").append(html);
            };

            // 在数据库中查询 照片是否已经存在了 请求添加的标签
            var addLabelAjax = function (newlabelName){
                $.ajax({
                    type:'post',
                    contentType : 'application/json;charset=utf-8',
                    url:"http://localhost:8080/pic/label/isLabelExist?lable="+newlabelName,
                    data:{},
                    success:function(data) {
                        if(data.exist){
                            return;
                        }else {
                            addLabel(newlabelName);
                        }
                    },
                    dataType:"json"
                });
            };
            // 移除添加的标签时获取 标签值
            $('body').on('click','.close',function(){
                alert("警告消息框被关闭--"+$(this).next().text());
            });


            //显示-添加
            $("#btnAdd").click(function(){
                $('#addName').val('');
                $('#addOperation-dialog').modal('show');
            });

            $("#btnEdit").click(function(){
                var node=$('#left-tree').treeview('getSelected');
                if (node.length == 0) {
                    showDialog( '请选中要修改的标签' );
                    return;
                }
                $('#alterOperation-dialog').modal('show');
            });
            //删除
            $("#btnDel").click(function(){
                var node = $('#left-tree').treeview('getSelected');
                if (node.length == 0) {
                    showDialog( '请选择标签' );
                    return;
                }

                BootstrapDialog.confirm({
                    title: '提示',
                    message: '确定删除此标签?',
                    size: BootstrapDialog.SIZE_SMALL,
                    type: BootstrapDialog.TYPE_DEFAULT,
                    closable: true,
                    btnCancelLabel: '取消',
                    btnOKLabel: '确定',
                    btnsOrder: BootstrapDialog.BUTTONS_ORDER_OK_CANCEL,   // 确定键在左侧
                    callback: function (result) {
                        if(result)
                        {
                            del();
                        }
                    }
                });
                function del(){

                    $('#left-tree').treeview('removeNode', [ node, { silent: true } ]);
                }

            });

            //获取树数据
            function getTree(){
                var tree = [
                    {
                        text: "p",
                        id:"1",
                        nodes: [
                            {
                                text: "一班",
                                id:"2",
                                nodes: [
                                    {
                                        text: "物理"
                                    },
                                    {
                                        text: "化学"
                                    }
                                ]
                            },
                            {
                                text: "二班"
                            }
                        ]
                    },
                    {
                        text: "二年级"
                    },
                    {
                        text: "三年级"
                    } ];
                return tree;
            }
            /*-----页面pannel内容区高度自适应 -----*/
            $(window).resize(function () {
                setCenterHeight();
            });
            setCenterHeight();
            function setCenterHeight() {
                var height = $(window).height();
                var centerHight = height - 240;
                $(".right_centent").height(centerHight).css("overflow", "auto");
            }
        });

        function showDialog( msg ) {
            BootstrapDialog.show({
                title: '提示',
                message: msg,
                size: BootstrapDialog.SIZE_SMALL,
                type: BootstrapDialog.TYPE_DEFAULT,
                buttons: [ {
                    label: '确定',
                    action: function ( dialog ) {
                        dialog.close();
                    }
                } ]
            });
        }
    </script>
</head>
<body >
<div id = "app">
<header class="container" style="margin-bottom: 35px;">
    <div class="row">
        <div class="col-md-4" >
            <input id="searchNode"  @keyup.enter="searchNode()" type="text" class="form-control"  placeholder="搜索标签">
        </div>
        <div class="col-md-8 pull-right" id="picTags" >
            <%--<input  @keyup.enter="searchNode()" type="text" class="form-control"  placeholder="显示已经存在的标签">--%>
        </div>
    </div>

    <div class="checkbox">
        <label>
            <input type="checkbox"  id="isAddLable" checked ='checked'> 给照片添加标签
        </label>
    </div>
</header>
<div class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="panel panel-primary ">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span data-placement="top" data-toggle="tooltip" title="<h5>点击管理标签</h5>" class="tooltip-show">
                            <span id = "tag" @click = "showTagHandle()"   class="glyphicon glyphicon-tag"></span>
                        </span>
                        <span id="btnAdd" v-show = "tagHandleStatu"   class="glyphicon glyphicon-plus"></span>
                        <span id="btnDel" v-show = "tagHandleStatu"   class="glyphicon glyphicon-trash"></span>
                        <span id="btnEdit" v-show = "tagHandleStatu"  class="glyphicon glyphicon-edit"></span>
                    </h3>
                </div>
                <div class="panel-body right_centent" style="">
                    <div id="left-tree"></div>
                </div>
            </div>
        </div>
        <div class="col-md-8 pull-right" style="float: right">
            <iframe src="pages/picture.jsp" name='main' id="iframepage" frameborder="0" width="100%" height="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe>
        </div> 
    </div>
</div>
<div>

    <!--弹出框 新增权限 start-->
    <div class="modal fade" id="addOperation-dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content radius_5">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">新增</h4>
                </div>
                <div class="modal-body">
                    <div group="" item="add">
                        <div>
                            <div class="input-group margin-t-5">
                                <span class="input-group-addon">名称:</span>
                                <input id="addName" type="text"  @keyup.enter="add_comfirm()"  placeholder="请输入新标签" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="Save" type="button" @click = "add_comfirm()" class="btn btn-primary">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
    <!--弹出框 新增权限 end-->

    <!--弹出框 新增权限 start-->
    <div class="modal fade" id="alterOperation-dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content radius_5">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel2">修改</h4>
                </div>
                <div class="modal-body">
                    <div group="" item="add">
                        <div>
                            <div class="input-group margin-t-5">
                                <span class="input-group-addon">名称:</span>
                                <input id="updateName" type="text" @keyup.enter="edit_comfirm()" class="form-control" />
                            </div>

                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button id="SaveAlter" type="button" @click = "edit_comfirm()" class="btn btn-primary">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>

                </div>
            </div>


        </div>
    </div>
    <!--弹出框 新增权限 end-->
</div>
</div>
</body>
<script>
    $(function () { $("[data-toggle='tooltip']").tooltip({html : true,container: 'body'}); });
    var vm = new Vue({
        el: '#app',
        data:{
            tagHandleStatu:false,
        },
        methods: {
            edit_comfirm: function () {
                $('#alterOperation-dialog').modal('hide');
                var node = $('#left-tree').treeview('getSelected');
                var newNode={
                    text:$('#updateName').val()
                };
                $('#left-tree').treeview('updateNode', [ node, newNode]);
            },
            add_comfirm: function () {
                $('#addOperation-dialog').modal('hide');
                //静态添加标签

                var parentNode = $('#left-tree').treeview('getSelected');
                var node = {
                    text: $('#addName').val()
                };

                var resNodes = $('#left-tree').treeview('search', [ $('#addName').val(), {
                    ignoreCase: true,     // case insensitive
                    exactMatch: true,    // like or equals
                    revealResults: true,  // reveal matching nodes
                }]);
                if(resNodes.length>0){
                    showDialog( "存在重复同名标签，请重新命名！" );
                }else {
                    $('#left-tree').treeview('addNode', [node, parentNode]);
                }

            },

            searchNode: function () {
                if($('#searchNode').val().trim() == ""){
                    showDialog( "请输入标签名后按回车键搜索..." );
                    return;
                }
                var resNodes = $('#left-tree').treeview('search', [ $('#searchNode').val(), {
                    ignoreCase: true,     // case insensitive
                    exactMatch: false,    // like or equals
                    revealResults: true,  // reveal matching nodes
                }]);
                if(resNodes.length == 0) {
                    BootstrapDialog.confirm({
                        title: '提示',
                        message: '标签不存在，是否创建?',
                        size: BootstrapDialog.SIZE_SMALL,
                        type: BootstrapDialog.TYPE_DEFAULT,
                        closable: true,
                        btnCancelLabel: '取消',
                        btnOKLabel: '确定',
                        btnsOrder: BootstrapDialog.BUTTONS_ORDER_OK_CANCEL,   // 确定键在左侧
                        callback: function (result) {
                            if (result) {
                                var node = {
                                    text: $('#searchNode').val()
                                };
                                $('#left-tree').treeview('addNode', [node, false]);
                            }
                        }
                    })
                };

            },
            // 切换状态
            showTagHandle: function () {
                this.tagHandleStatu = !this.tagHandleStatu;
            },
        },
    });
</script>
<%--<script>
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

  /*  $('#tree').treeview('search', [ 'c', {
        ignoreCase: true,     // case insensitive
        exactMatch: false,    // like or equals
        revealResults: true,  // reveal matching nodes
    }]);*/
    // $('#tree').treeview('findNodes', ['一', '一']);
    // $('#tree').treeview('selectNode', [ 0, { silent: true } ]); // 选中 指定 id的标签
    $('#tree').on('nodeSelected', function(event, data) { // 触发选中事件
        // $('#tree').treeview('disableNode', [ data, { silent: true, keepState: true } ]);


        // alert(JSON.stringify(tempNode));
        var newNode =  {
            text: '新增的标签',
            href: '#',
            tags: ['0']
        };
        var tempNode =  $('#tree').treeview('getSelected');
        /*  If parentNode evaluates to false, node will be added to root
       If index evaluates to false, node will be appended to the nodes */
        var parentNode = false;
        // 0 代表 一级标签 在开头
        // 1 或者其他  代表 二级标签
        $('#tree').treeview('addNode', [ newNode, tempNode, false, { silent: true } ]);

        // 在标签之后添加 新标签
        // $('#tree').treeview('addNodeAfter', [ newNode, tempNode, { silent: true } ]);
        // 更新标签
        // $('#tree').treeview('updateNode', [ tempNode, newNode, { silent: true } ]);
        // 移除标签
        // $('#tree').treeview('removeNode', [ tempNode, { silent: true } ]);
    });





    $('#tree').treeview('addNode', [ nodes2, parentNode, 1, { silent: true } ]);

    $('#tree').treeview('disableNode', [ nodes2, { silent: true, keepState: true } ]);


    // var node = false;
    // $('#tree').treeview('addNodeAfter', [ nodes, node, { silent: true } ]);



</script>--%>
</html>
