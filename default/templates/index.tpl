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
      <v-app-bar app color="blue darken-1" dense dark v-if="work">
        <v-btn @click="drawer = !drawer" icon><v-icon>fas fa-bars</v-icon></v-btn>
        <v-toolbar-title>{{title}}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn color="lime darken-2" class="font-weight-bold">
            <v-icon left>fa-plus</v-icon>&nbsp;New Script
        </v-btn>
        <v-spacer></v-spacer>
          <v-menu bottom left :open-on-hover = true >
            <template v-slot:activator="{ on }">
              <v-btn
                dark
                icon
                v-on="on"
              >
                <v-icon>fa-ellipsis-v</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item
                v-for="(item, i) in activemenu()"
                :key="i"
                @click=item.onclick
              >
                <v-icon class="pr-2">{{ item.icon }}</v-icon>
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
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
          >
            <div style="width: 48px;">
              <v-icon size="32px">{{ item.icon }}</v-icon>
            </div>

            <v-list-item-content>
              <v-list-item-title  class="font-weight-bold">{{ item.title }}</v-list-item-title>
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
    <dlg-question :show="question" :title="asktitle" @close="question = false" v-on:yes="cmd" />
  </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vue-router.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>

[[template "home" .]]
[[template "editor" .]]
[[template "help" .]]
[[template "shutdown"]]
[[template "dialogs"]]

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
  {
    path: '/shutdown',
    name: 3,
    component: Shutdown,
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
      },
      reload() {
        axios
        .get('/api/reload')
        .then(response => (location.reload(true)));
      },
      exit() {
        this.question = false;
        this.drawer = false;
        this.work = false;
        axios
        .get('/api/exit')
        .then(response => (router.push('shutdown')));
      },
      confirm( title, fn ) {
        this.asktitle = title;
        this.cmd = fn;
        this.question = true;
      },
      activemenu() {
        return this.menus.filter( (i) => !i.hide );
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
      work: true,
      develop: [[.Develop]],
      navitems: [
        { id: 0, title: [[lang "scripts"]], icon: 'fa-play-circle', route: '/' },
        { id: 1, title: [[lang "editor"]], icon: 'fa-edit', route: '/editor' },
        { id: 2, title: [[lang "help"]], icon: 'fa-life-ring', route: '/help' },
//        { id: 3, title: 'Support', icon: 'fa-life-ring' },
      ],
      menus: [
        { title: [[lang "refresh"]], icon: "fa-redo-alt", onclick: this.reload, 
             hide: [[not .Develop]]},
        { title: [[lang "exit"]], icon: "fa-power-off", 
          onclick: () => this.confirm([[lang "exitconfirm"]], this.exit) },
      ],
      question: false,
      asktitle: "",
      cmd: null,
    }
}
</script>

</body>
</html>

