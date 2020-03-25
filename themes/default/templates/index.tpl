<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .App.Title ]]</title>
  <link rel="icon" href="/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <link rel="stylesheet" href="/css/fontawesome.min.css">
  <link rel="stylesheet" href="/css/eonza.css">
  <!--link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet"-->
</head>
<body>
<div id = "app">
  <v-app  style="height:100%;">
      <v-app-bar app color="blue darken-1" dense dark v-if="work">
        <v-btn @click="drawer = !drawer" icon><v-icon>fas fa-bars</v-icon></v-btn>
        <v-toolbar-title>{{store.state.title}}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn color="primary" to="/editor?scriptname=new" class="white  font-weight-bold" outlined v-if="$route.name != 1">
            <v-icon small left>fa-plus</v-icon>&nbsp;[[lang "newscript"]]
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
                <v-icon small class="pr-2">{{ item.icon }}</v-icon>
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

          <v-list-item :to="item.route"
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
          <v-list-item :to="item.route"
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
    <v-content app style="height:100%;">
    <router-view></router-view>
    </v-content>
    <dlg-question :show="question" :title="asktitle" v-on:btn="cmd"></dlg-question>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
    <dlg-commands :show="newcmd" v-on:cmdname="newcmdfn"></dlg-commands>
  </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vue-router.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>
<script src="/js/vuex.min.js"></script>

[[template "home" .]]
[[template "tree" .]]
[[template "card" .]]
[[template "editor" .]]
[[template "help" .]]
[[template "shutdown"]]
[[template "dialogs"]]

<script>
const routes = [{
    path: '/',
    name: 0,
    component: Home
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

const store = new Vuex.Store({
  state: {
      title: '',
      changed: false,
      loaded: false,
      active: null,
      list: null,
      clipboard: null,
      script: {
          settings: {
          },
          tree: {
            children: [],
          }
      },
  },
  mutations: {
    updateTitle (state, title) {
      state.title = title;
    },
    updateScript (state, script) {
      state.script = script;
    },
    updateLoaded (state, loaded) {
      state.loaded = loaded;
    },
    updateChanged (state, changed) {
      state.changed = changed;
    },
    updateActive (state, active) {
      state.active = active;
    },
    updateList (state, list) {
      state.list = list;
    },
    updateClipboard (state, value) {
      state.clipboard = value;
    },
  }
})

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    router,
    store,
    methods: {
      errmsg( title ) {
        this.errtitle = title;
        this.error = true;
      },
      saveScript(callback) {
        axios
        .post('/api/script', store.state.script)
        .then(response => { 
          if (!response.data.error) {
            store.commit('updateChanged', false);
            if (store.state.script.original != store.state.script.settings.name) {
              store.state.script.original = store.state.script.settings.name;
              store.commit('updateScript', store.state.script);
            }
            if (typeof callback == 'function') {
              callback();
            }
          } else {
            this.errmsg(response.data.error);
          }
        });
      },
      checkChanged(fn) {
        if (store.state.changed) {
          let parent = this;
           this.confirm( format([[lang "savescript"]], store.state.script.settings.title), 
            function( par ){
             parent.question = false;
             if (par == btn.Yes) {
                parent.saveScript(fn);
                return; 
             } else {
               store.commit('updateChanged', false);
             }
             fn();
           });
        } else {
          fn();
        }
      },
      reload() {
        this.checkChanged(()=> {
          axios
          .get('/api/reload')
          .then(response => (location.reload(true)));
        });
      },
      exit( par ) {
        this.question = false;
        if (par == btn.Yes) {
          this.checkChanged(()=> {
            this.drawer = false;
            this.work = false;
            axios
            .get('/api/exit')
            .then(response => (router.push('shutdown')));
          });
        }
      },
      newCommand( fn ) {
        this.newcmdfn = (par) => {
          this.newcmd = false;
          fn(par);
        }
        this.newcmd = true;
      },
      confirm( title, fn ) {
        this.asktitle = title;
        this.cmd = fn;
        this.question = true;
      },
      activemenu() {
        return this.menus.filter( (i) => !i.hide );
      },
      loadList( fn ) {
        axios
        .get('/api/list?cache='+this.cache)
        .then(response => {
            if (response.data.error) {
                this.errmsg(response.data.error);
                return
            }
            if (response.data.cache != this.cache) {
              store.commit('updateList', response.data.list);
              this.cache = response.data.cache;
            }
            if (!!fn && typeof fn == 'function') {
              fn();
            }
        })
        .catch(error => this.errmsg(error));
      },
      filterList(search) {
            let ret = [];
            for (let key in store.state.list) {
              let val = store.state.list[key];
              if (!val.title) continue;
              let weight = 0;
              if (!!search) {
                const lower = search.toLowerCase();
                if (val.name.startsWith(lower)) {
                  weight = 8;
                }
                if (val.title.toLowerCase().includes(lower)) {
                  weight += 4;
                }
                if (val.desc && val.desc.toLowerCase().includes(lower)) {
                  weight += 2;
                }
                if (!weight) continue;
                if (!val.embedded) {
                  weight += 1;
                }
              } 
              val.weight = weight;
              ret.push(val);
            }
            ret.sort(function(a,b) {
              if (a.weight != b.weight) return a.weight - b.weight;
              return a.title.localeCompare(b.title);
            });
            return ret;
        },
    },
})

function appData() { 
    return {
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
      error: false,
      errtitle: '',
      cache: 0,
      newcmd: false,
      newcmdfn: null,
    }
}

function format(pattern, par) {
    return pattern.replace('%s', par);
}

function desc(item) {
  if (item.desc) {
    return item.desc;
  } 
  return item.name;
}

</script>

</body>
</html>

