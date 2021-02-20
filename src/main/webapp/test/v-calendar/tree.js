// vue-router数据结构
const routes = [
    {
        name: 'home',
        path: '/home',
        meta: { text: '首页' }
    },
    {
        name: 'inner',
        path: '/inner',
        meta: { text: '内部平台' },
        children: [
            {
                name: 'oa',
                path: 'oa',
                meta: { text: 'OA' }
            },
            {
                name: 'jira',
                path: 'jira',
                meta: { text: 'Jira' }
            },
            {
                name: 'wiki',
                path: 'wiki',
                meta: { text: 'Wiki' }
            },
            {
                name: 'caiwu',
                path: 'caiwu',
                meta: { text: '财务' },
                children: [
                    {
                        name: 'chailv',
                        path: 'chailv',
                        meta: { text: '差旅' }
                    },
                    {
                        name: 'richang',
                        path: 'richang',
                        meta: { text: '日常' },
                        children: [
                            {
                                name: 'taxi',
                                path: 'taxi',
                                meta: { text: '交通' }
                            },
                            {
                                name: 'tel',
                                path: 'tel',
                                meta: { text: '通信' }
                            }
                        ]
                    }
                ]
            }
        ]
    },
    {
        name: 'sec',
        path: '/sec',
        meta: { text: '审核' },
        children: [
            {
                name: 'acl',
                path: '/acl',
                meta: { text: 'ACL' }
            }
        ]
    }
]

// 菜单组件
const treeMenu = {
    props: {
        routes: {
            type: Array,
            default () {
                return []
            }
        }
    },
    methods: {
        elements (routes, r) {
            return routes
                .map(route => {
                if (!route.paths) route.paths = []
            if (route.children && route.children.length) {
                return r(
                    'el-submenu',
                    {
                        props: {
                            index: route.name
                        }
                    },
                    [
                        r(
                            'span',
                            {
                                slot: 'title'
                            },
                            [
                                route.meta.text
                            ]
                        ),
                        this.elements(route.children, r)
                    ]
                )
            } else if (route.path) {
                return r(
                    'el-menu-item',
                    {
                        props: {
                            index: route.name
                        }
                    },
                    [
                        route.meta.text
                    ]
                )
            } else {
                return null
            }
        })
        .filter(item => item)
        },
        onSelect (index) {
            console.log('>>>', index)
        }
    },
    render (r) {
        return r(
            'el-menu',
            {
                props: {
                    backgroundColor: "#545c64",
                    textColor: "#fff",
                    activeTextColor: "#ffd04b"
                },
                on: {
                    select: this.onSelect
                }
            },
            this.elements(this.routes, r)
        )
    }
}

// app
const app = new Vue({
    el: '#app',
    replace: false,
    components: {
        treeMenu
    },
    data: {
        routes
    }
})