<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .App.Title ]]</title>
  <link rel="icon" href="/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <script src="/js/fontawesome.min.js"></script>
  <script src="/js/solid.min.js"></script>
  <script src="/js/brands.min.js"></script>
  <style type="text/css">
  body {
      font-family: Verdana,Arial;
  }
  </style>
</head>
<body>
<div id = "app">
    <v-app>
      <v-app-bar app  color="blue darken-1" dense dark>
        <v-btn @click="drawer = !drawer" icon><v-icon>fas fa-bars</v-icon></v-btn>
        <v-toolbar-title>{{title}}</v-toolbar-title>
        <v-spacer></v-spacer>
      </v-app-bar>

      <v-navigation-drawer
        app
        absolute
        dark
        v-model="drawer"
      >
      <div class="d-flex flex-column justify-space-between" style="height: 100%;">
      <div>
        <v-list
          nav
          class="py-0"
        >
          <v-list-item two-line href="[[.App.Homepage]]" target="_blank" title="Homepage">
            <v-list-item-avatar>
              <img src="/images/logo-48.png">
            </v-list-item-avatar>

            <v-list-item-content>
              <div>[[.App.Title]]</div>
              <v-list-item-subtitle>v[[.Version]]</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>

          <v-divider></v-divider>

          <v-list-item :to="item.route" @click="change(item.id)"
            v-for="item in navitems"
            :key="item.title"
            v-if="item.id < 2"
            link
          >
            <div style="width: 48px;">
              <v-icon size="32px">{{ item.icon }}</v-icon>
            </div>

            <v-list-item-content>
              <v-list-item-title class="font-weight-bold">{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-divider></v-divider>
          <v-list-item :to="item.route" @click="change(item.id)"
            v-for="item in navitems"
            :key="item.title"
            v-if="item.id > 1"
            link
            dense
          >
            <div style="width: 48px;">
              <v-icon>{{ item.icon }}</v-icon>
            </div>

            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
          </div>
    <div>
    <v-container class="text-center white--text body-2">
       <v-divider></v-divider>
      <div class="pt-1">[[.App.Copyright]]</div>
    </v-container>
    </div>
    </div>
      </v-navigation-drawer>

    <v-content app>
    <router-view></router-view>
    </v-content>
</v-app>
<script src="/js/vue.min.js"></script>
<script src="/js/vue-router.min.js"></script>
<script src="/js/vuetify.min.js"></script>

[[template "home"]]
[[template "editor"]]
[[template "help" .]]

<script>
const routes = [{
    path: '/',
    name: 0,
    component: Scripts
  },
  {
    path: '/editor',
    name: 1,
    component: Editor
  },
  {
    path: '/help',
    name: 2,
    component: Help,
  },
];

const router = new VueRouter({ routes });

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'faSvg',
      },
    }),
    el: '#app',
    data: appData,
    router,
    methods: {
      change(id) {
        this.title = this.navitems[id].title;
      }
    },
    mounted() {
      this.change(this.$route.name);
    }
})

function appData() { 
    return {
      title: "",
      drawer: true,
      navitems: [
        { id: 0, title: [[lang "scripts"]], icon: 'fa-play-circle', route: '/' },
        { id: 1, title: [[lang "editor"]], icon: 'fa-edit', route: '/editor' },
        { id: 2, title: [[lang "help"]], icon: 'fa-life-ring', route: '/help' },
//        { id: 3, title: 'Support', icon: 'fa-life-ring' },
      ],
    }
}
</script>
</body>
</html>

