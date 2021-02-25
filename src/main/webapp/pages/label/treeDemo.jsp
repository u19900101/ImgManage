<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/pages/head.jsp"%>
	<%-- 这个js 还必须在当前页面才能引入--%>
	<script src="static/script/bootstrap-treeview.js"></script>
</head>
<body>

	<div  style="width: 20%;float: left">
		<h2>标签</h2>
		<div id="treeview6" class=""></div>
	</div>


	<div style="width: 80%;float: right" >
        <iframe src="pages/picture.jsp" name='main' id="iframepage" frameborder="0" width="100%" height="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe>
	</div> 

	<script type="text/javascript">

    $(function() {
		var defaultData = ${labels};
		/*var defaultData = [
			{
				nodes: [
					{
						text: 'Child 1',
						href: 'https://google.com',
						tags: ['2344'],
						nodes: [
							{
								nodeId:"kkk",
								text: '我是kkk',
								href: 'https://google.com',
								icon:  "glyphicon glyphicon-user",
								tags: ['100000']
							},
							{
								text: 'Grandchild 2',
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
				text: 'Parent 11111',
				href: '#',
				tags: ['4'],
			}];*/
		$('#treeview6').treeview({
			color: "#000000",
			backColor: "#FFFFFF",
			// enableLinks: true,
			expandIcon: "glyphicon glyphicon-chevron-right",
			collapseIcon: "glyphicon glyphicon-chevron-down",
			nodeIcon: "glyphicon glyphicon-bookmark",
			showTags: true,
			data: defaultData,

		});
		//设置页面初始化时展开的节点
		/*$('#treeview6').treeview('expandNode',
				[0, {
			levels: 3,
			silent: true
		}],
				[1, {
			levels: 3,
			silent: true
		}]);*/
		//全部折叠起来 collapseAll
		// $('#treeview6').treeview('collapseAll', {data:defaultData});

		// //全部展开 expandAll
		$('#treeview6').treeview('expandAll', {data:defaultData});

		$('#treeview6').on('nodeSelected', function(event, data) {
			// clickNode(event, data)
			/*alert(JSON.stringify(data));
			alert(data.text);
			alert(data.nodeId);*/
			// 点击后  访问后台的路径  后台处理完数据后直接渲染 到指定的页面去
			document.getElementById("iframepage").src="/pic/" + data.href;
		});
		/*$('#treeview6').on('nodeSelected',function(event,data){   //插件中的方法
			alert(data.nodeId);
			/!*switch(data.nodeId){
				case 0:break;
				case 1:
					testGrandfather(); //当点击结点id为1的那个结点时，调用该函数实现跳转等效果
					break;
				case "kk":
					testGrandfather();
					break;

			}*!/
		});*/

		function testGrandfather(){
			//window.location.href="跳转地址";   //界面跳转
			alert("节点id为1");
			/*$.ajax({                           //异步请求
				url:url,
				type:'post',
				dataType:"json",
				async:false,
				data:{},
				success:function(data){
					//将后台的数据返回给前端界面
					//前端界面对其进行处理，达到要展示的效果。
				},
				error:function(){

				}

			});*/
		}

		// 首先要明确：树结构数据、初始化选中数据:
		// 以本文为例，从接口获取的数据分别为：menuTreeArr, selectedArr([1,2,3,4...])
		// 将数据拆解为插件要求的数据格式：（建议递归）
		/*function menuTreeTrans(data, selectedArr) {
			var tree = [];
			for (var i = 0; i < data.length; i++) {
				var obj = {
					id: data[i].id,
					text: data[i].text,
					selectable: false,
					// 已check节点默认展开和check
					state: {
						checked: selectedArr.indexOf(data[i].id) > -1,
						expanded: selectedArr.indexOf(data[i].id) > -1,
					}
				};
				if (data[i].children && data[i].children.length > 0) {
					obj.nodes = menuTreeTrans(data[i].children, selectedArr);
				}
				tree.push(obj);
			}
			return tree;
		};
		// 初始化菜单
		var data = menuTreeTrans(menuTreeArr, selectedArr);

		$('#treeview7').treeview({
			// color: "#428bca",
			color: "#000000",
			backColor: "#FFFFFF",
			enableLinks: true,
			expandIcon: "glyphicon glyphicon-chevron-right",
			collapseIcon: "glyphicon glyphicon-chevron-down",
			nodeIcon: "glyphicon glyphicon-bookmark",
			showTags: true,
			data: data
		});*/

  		});
	  	</script>
</body>
</html>