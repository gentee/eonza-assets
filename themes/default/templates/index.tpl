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
            <v-icon small left>fa-plus</v-icon>&nbsp;%newscript%
        </v-btn>
        <v-btn color="primary" :href="'https://www.eonza.org' + store.state.help" target="_help" class="white  font-weight-bold mx-4" outlined>
            <v-icon small left>fa-question</v-icon>&nbsp;%help%
        </v-btn>
        <v-spacer></v-spacer>
          [[if .Develop]]
              <v-chip color="cyan" text-color="white"><strong>develop</strong></v-chip>
          [[end]]
          [[if .Playground]]
              <v-chip color="orange" text-color="white"><strong>playground</strong></v-chip>
          [[end]]
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
            v-if="item.id < 3"
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
            v-if="item.id > 2"
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
    <!--v-container class="text-center white--text body-2">
       <v-divider></v-divider>
      <div class="pt-1">[[.App.Copyright]]</div>
    </v-container-->
    </div>
    </div>
      </v-navigation-drawer>
    <v-content app style="height:100%;">
    <router-view></router-view>
    </v-content>
    <dlg-upload :show="upload" :title="uploadtitle" v-on:btn="cmd"></dlg-upload>
    <dlg-question :show="question" :title="asktitle" v-on:btn="cmd"></dlg-question>
    <dlg-error :show="error" :title="errtitle" :callback="callback" @close="error = false"></dlg-error>
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
[[template "dyncomp" .]]
[[template "card" .]]
[[template "editor" .]]
[[template "tasks" .]]
[[template "settings" .]]
[[template "help" .]]
[[template "shutdown"]]
[[template "dialogs"]]
[[template "cardlist" .]]

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
    path: '/tasks',
    name: 2,
    component: Tasks
  },
  {
    path: '/settings',
    name: 3,
    component: Settings,
  },
  {
    path: '/help',
    name: 4,
    component: Help,
  },
  {
    path: '/shutdown',
    name: 5,
    component: Shutdown,
  },
];

const router = new VueRouter({ routes });

const store = new Vuex.Store({
  state: {
      title: '',
      help: '/',
      changed: false,
      loaded: false,
      active: null,
      list: null,
      tasks: [],
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
    updateHelp (state, url) {
      state.help = url;
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
    updateTasks (state, tasks) {
      state.tasks = tasks;
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
      errmsg( title, callback = null ) {
        this.errtitle = title;
        this.error = true;
        this.callback = callback
      },
      run(name, silent, callback) {
        axios
        .get('/api/run?name=' + name + (silent ? '&silent=true' : '' ))
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error, callback);
                return
            }
            [[if not .Localhost]] 
              if (!silent) {
                async function hostrun(root, id) {
                  let task
                  for (let i = 0; i < 15; i++) {
                    task = root.getTask(id)
                    if (task) {
                      break
                    }
                    await sleep(200)
                  }
                  if (!task) {
                    root.errmsg('Unfortunately, the task has not been found. Try to find it in Task Manager.');
                    return
                  }
                  window.open(window.location.protocol + '//' + window.location.hostname + ':' + task.port,
                    '_blank');
                };
                hostrun(this, response.data.id);
              }
            [[end]]
        })
        .catch(error => this.$root.errmsg(error));
      },
      saveScript(callback) {
        axios
        .post('/api/script', omit(store.state.script))
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
           this.confirm( format("%savescript%", store.state.script.settings.title), 
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
          .then(response => (location.reload()));
        });
      },
      logout() {
        this.checkChanged(()=> {
          axios
          .get('/api/logout')
          .then(response => (location.reload()));
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
      confirmYes( title, fn ) {
        this.asktitle = title;
        this.cmd = (par) => {
          this.question = false;
          if (par == btn.Yes) {
             fn();
          }
        }
        this.question = true;
      },
      uploadDlg( title, fn ) {
        this.uploadtitle = title;
        this.cmd = (par) => {
          this.upload = false;
          if (par.btn == btn.OK) {
             fn(par);
          }
        }
        this.upload = true;
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
              store.commit('updateList', response.data.map);
              this.cache = response.data.cache;
            }
            if (!!fn && typeof fn == 'function') {
              fn();
            }
        })
        .catch(error => this.errmsg(error));
      },
      loadTasks() {
        axios
        .get('/api/tasks')
        .then(response => {
            if (response.data.error) {
                this.errmsg(response.data.error);
                return
            }
            store.commit('updateTasks', response.data.list);
        })
        .catch(error => this.errmsg(error));
      },
      getTask(id) {
         for (let i = 0; i<store.state.tasks.length; i++) {
           if (store.state.tasks[i].id == id ) {
             return store.state.tasks[i]
           }
         }
         return null
      },
      filterList(search,all) {
            let ret = [];
            for (let key in store.state.list) {
              let val = store.state.list[key];
              if (!val.title || (!all && !search && val.embedded)) continue;
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
              if (a.weight != b.weight) return b.weight - a.weight;
              return a.title.localeCompare(b.title);
            });
            return ret;
        },
        connect() {
          this.socket = new WebSocket(wsUri())
          this.socket.onopen = () => {};
          this.socket.onmessage = this.wsCmd
          this.socket.onclose = () => {}
        },
        wsCmd({data}) {
          let cmd = JSON.parse(data);
          if (cmd.cmd == WcStatus) {
            let list = store.state.tasks
            let i = 0
            for (; i < list.length; i++) {
              if (list[i].id == cmd.taskid) {
                list[i].status = cmd.status
                if (cmd.message) {
                  list[i].message = cmd.message
                }
                if (cmd.finish && cmd.status >= stFinished) {
                  list[i].finish = cmd.finish
                }
              }
            }
            if (!!cmd.task && i == list.length ) {
              list.push(cmd.task)
            }
            store.commit('updateTasks', list);
          }
        },
    },
    mounted() {
      this.loadTasks()
      this.connect()
    }
})

function appData() { 
    return {
      drawer: true,
      work: true,
      develop: [[.Develop]],
      navitems: [
        { id: 0, title: '%scripts%', icon: 'fa-play-circle', route: '/' },
        { id: 1, title: '%editor%', icon: 'fa-edit', route: '/editor' },
        { id: 2, title: '%taskmanager%', icon: 'fa-tasks', route: '/tasks' },
        { id: 3, title: '%settings%', icon: 'fa-tools', route: '/settings' },
        { id: 4, title: '%help%', icon: 'fa-life-ring', route: '/help' },
//        { id: 3, title: 'Support', icon: 'fa-life-ring' },
      ],
      menus: [
        { title: '%refresh%', icon: "fa-redo-alt", onclick: this.reload, 
             hide: [[not .Develop]]},
        { title: '%logout%', icon: "fa-sign-out-alt", onclick: this.logout, 
             hide: [[not .Login]]},
        { title: '%exit%', icon: "fa-power-off", 
          onclick: () => this.confirm("%exitconfirm%", this.exit) },
      ],
      question: false,
      asktitle: "",
      upload: false,
      uploadtitle: "",
      cmd: null,
      error: false,
      errtitle: '',
      cache: 0,
      newcmd: false,
      newcmdfn: null,
      socket: null,
      callback: null,
    }
}

function omit(obj) {
  if (obj instanceof Array) {
     let ret = [];
     for (let i=0; i<obj.length; i++) {
       ret.push(omit( obj[i] ));
     }
     return ret;
  }
  if (typeof obj == 'object') {
    let ret = {}
    for (const key in obj) {
      if (!key.startsWith('__')) {
        ret[key] = omit(obj[key])
      }
    }
    return ret;
  }
  return obj;
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

function clone(src) {
  return JSON.parse(JSON.stringify(omit(src)));
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

</script>

</body>
</html>

