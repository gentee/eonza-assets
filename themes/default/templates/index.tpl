<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[if .Title]][[.Title]][[end]][[if not .Title]][[ .App.Title ]][[end]]</title>
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
      <v-app-bar app color="blue darken-1" dense dark v-if="work" style="margin-top:32px">
        <div style="top:-32px;left:0;width: 100%;position:absolute;height: 32px;padding: 1px 4px 0px 4px;background-color: #fff;display:flex;justify-content:flex-start">
           <v-icon color="yellow darken-1" small>fa-star</v-icon>
          <v-btn small class="px-2 ml-1" icon color="blue lighten-2" 
            @click="favShift(-1)" v-show="leftfav">
            <v-icon>fa-caret-left</v-icon>      
          </v-btn>
           <div style="display:inline-flex;flex-shrink:1;justify-content:flex-start;overflow:hidden" id="favlist" ref="favlist">
              <div v-for="(fav,index) in store.state.favs">
                <v-btn small class="px-2 ml-1" style="text-transform: none;" light color="blue lighten-4" v-if="!fav.isfolder" @click="run(fav.name)">{{favTitle(fav.name)}}</v-btn>
           <v-menu bottom left :open-on-hover = true v-if="fav.isfolder">
            <template v-slot:activator="{ on }">
              <v-btn small class="px-2 ml-1" style="text-transform: none;background-color: #FFF9C4" light v-on="on" v-if="fav.isfolder">
                {{fav.name}}
              </v-btn>
            </template>
            <v-card class="pa-2" >
             <div style="display: flex;flex-direction:column;">
             <v-btn v-for="(sub,index) in fav.children" small class="px-2 my-1" style="text-transform: none;" light color="blue lighten-4"  @click="run(sub.name)">{{favTitle(sub.name)}}</v-btn>
             </div>
            </v-card>
          </v-menu>
              </div>
           </div>
           <v-btn small class="px-2 ml-1" icon color="blue lighten-2" style="flex-shrink: 0" 
             @click="favShift(1)" v-show="rightfav">
              <v-icon>fa-caret-right</v-icon>      
           </v-btn>

        </div> 
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
              <v-chip color="orange" text-color="white" href="https://www.eonza.org/docs/playground.html" 
              target="_help"><strong>playground</strong>
              <v-icon right color="white">
               fa-question-circle
              </v-icon></v-chip>
          [[end]]
          [[if not .Playground]]
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
          [[end]]
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
        [[if .Title]]
          <v-list-item style="margin:0">
            <v-list-item-content class="pb-0">
              [[.Title]]
            </v-list-item-content>
          </v-list-item>
          <v-list-item style="min-height: 24px;padding:0px 8px;margin-bottom:4px" one-line href="[[.App.Homepage]]" target="_blank" title="Homepage">
            <v-list-item-avatar size="24">
              <img src="/images/logo-48.png">
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-subtitle>[[.App.Title]] v[[.Version]]</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        [[end]]
        [[if not .Title]]
            <v-list-item two-line class="py-0" href="[[.App.Homepage]]" target="_blank" title="Homepage">
            <v-list-item-avatar>
              <img src="/images/logo-48.png">
            </v-list-item-avatar>

            <v-list-item-content class="py-0">
              <div>[[.App.Title]]</div>
              <v-list-item-subtitle>v[[.Version]]</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        [[end]]
          <v-divider class="mb-2"></v-divider>

          <v-list-item :to="item.route"
            v-for="item in navitems"
            :key="item.title"
            v-if="item.id < 3"
            link
          >
            <div style="width: 44px;">
              <v-icon size="28px">{{ item.icon }}</v-icon>
            </div>

            <v-list-item-content>
              <v-list-item-title class="font-weight-bold">{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-divider class="mb-2"></v-divider>
          <v-list-item :to="item.route"
            v-for="item in navitems"
            :key="item.title"
            v-if="item.id > 2"
            link
          >
            <div style="width: 44px;">
              <v-badge v-if="item.id==4" :content="store.state.unread" :value="store.state.unread" color="red darken-2" overlap>
                 <v-icon size="28px">{{ item.icon }}</v-icon>
              </v-badge>
              <v-icon size="28px" v-else>{{ item.icon }}</v-icon>
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
[[template "notifications" .]]
[[template "settings" .]]
[[template "help" .]]
[[template "shutdown" .]]
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
  {
    path: '/notifications',
    name: 6,
    component: Notifications,
  },
];

let deffavs = [
   [[range .Favs]]
     {name: [[.Name]], isfolder: [[.IsFolder]], [[if .Children]]
      children: [
         [[range .Children]]{name: [[.Name]]},
         [[end]]]
     [[end]]},
  [[end]]
];

let defisfav = {
   [[range .Favs]]
       [[if .IsFolder]][[range .Children]][[.Name]]: true, [[end]]
       [[else]][[.Name]]: true,[[end]]
   [[end]]
};

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
      nfy: nfy.list,
      unread: nfy.unread,
      isfav: defisfav,
      favs: deffavs,
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
    updateNfy (state, nfy) {
      state.nfy = nfy;
    },
    updateUnread (state, unread) {
      state.unread = unread;
    },
    updateFavs (state, data) {
      let isFav = {}
      newFav = [...state.favs]
      let move = data.action
      let deleted = null
      if (move == 'after' || move == 'before') {
        data.action = 'delete'
      }
      if (data.isfolder) {
         if (data.action == 'new') {
            newFav.push({name: data.name, isfolder: true, children: []})
         } else if (data.action == 'delete') {
            for (let i = 0; i < newFav.length; i++ ) {
                let item = newFav[i]
                if (item.isfolder && item.name == data.name) {
                  newFav.splice(i, 1)
                  break
                }
            }
         }
      } else {
        if (data.action == 'new') {
           if (!!data.folder) {
            for (let i = 0; i < newFav.length; i++ ) {
                let item = newFav[i]
                if (item.isfolder && item.name == data.folder) {
                  if (!newFav[i].children) {
                    newFav[i].children = []  
                  }
                  newFav[i].children.push({name: data.name})    
                  break
                }
            }
           } else {
              newFav.push({name: data.name})
           }
        } else if (data.action == 'delete') {
          for (let i = 0; i < newFav.length; i++ ) {
            let item = newFav[i]
            if (item.isfolder && item.children) {
                for (let j = 0; j < item.children.length; j++ ) {
                  if (item.children[j].name == data.name) {
                      deleted = newFav[i].children.splice(j, 1)
                      break
                  }
                }
            } else if (item.name == data.name) {
                deleted = newFav.splice(i, 1)
            }
          }
        }
      }
      if ((move == 'after' || move == 'before') && deleted) {
        let index = 0
        if (data.folder && !deleted[0].isfolder) {
          for (let i = 0; i < newFav.length; i++ ) {
            if (newFav[i].isfolder && newFav[i].name == data.folder) {
              if (data.target) {
                for (let j = 0; j < newFav[i].children.length; j++ ) {
                  if (newFav[i].children[j].name == data.target) {
                    index = move == 'after' ? j+1: j
                    break
                  }
                }
              }
              if (!newFav[i].children) {
                newFav[i].children = deleted
              } else {
                 newFav[i].children.splice(index, 0, deleted[0])
              }
              break
            }
          }
        } else {
          if (data.target) {
            for (let i = 0; i < newFav.length; i++ ) {
              if (newFav[i].name == data.target) {
                index = move == 'after' ? i+1: i
                break
              }
            }
          }
          newFav.splice(index, 0, deleted[0])
        }
      }
      for (let i = 0; i < newFav.length; i++ ) {
        let item = newFav[i]
        if (item.isfolder && item.children) {
            for (let j = 0; j < item.children.length; j++ ) {
              isFav[item.children[j].name] = true
            }
        } else {
          isFav[item.name] = true
        }
      }
      state.isfav = isFav
      state.favs = newFav
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
      favTitle(name) {
        if (store.state.list && store.state.list[name]) {
           return store.state.list[name].title
        }
        return name
      },
      errmsg( title, callback = null ) {
        this.errtitle = title;
        this.error = true;
        this.callback = callback
      },
      saveFavs() {
        axios
          .post(`/api/favs`, store.state.favs)
          .then(response => {
              if (response.data.error) {
                  this.errmsg(response.data.error);
                  return
              }
          })
          .catch(error => this.errmsg(error));
      },
      run(name, silent, callback) {
        let comp = this
        axios
        .get('/api/run?name=' + name + (silent ? '&silent=true' : '' ))
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error, callback);
                return
            }
            [[if not .Localhost]] 
              if (!silent) {
                async function hostrun(root, id, port) {
                  let task
                  for (let i = 0; i < 8; i++) {
                    task = root.getTask(id)
                    if (task) {
                      break
                    }
                    await sleep(200)
                  }
                  if (!task) {
//                    root.errmsg('Unfortunately, the task has not been found. Try to find it in the Task Manager.');
//                    return
                    comp.connect()
                    task = {port: port}
                  }
                  let portTask = task.port + [[.PortShift]]
                  window.open(window.location.protocol + '//' + window.location.hostname + ':' + portTask,
                    '_blank');
                };
                hostrun(this, response.data.id, response.data.port);
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
      checkChanged(fn, editor) {
        if (store.state.changed) {
          let parent = this;
           this.confirm( format("%savescript%", store.state.script.settings.title), 
            function( par ){
             parent.question = false;
             if (par == btn.Yes) {
                parent.saveScript(fn);
                return; 
             } else if (!editor) {
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
            axios
            .get('/api/exit')
            .then(response => { 
              if (!response.data.error) {
                this.drawer = false;
                this.work = false;
                router.push('shutdown')
              } else {
                this.errmsg(response.data.error)
              }
            });
          })
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
      loadNfy() {
        axios
        .get('/api/notifications')
        .then(response => {
            if (response.data.error) {
                this.errmsg(response.data.error);
                return
            }
            store.commit('updateNfy', response.data.list);
            store.commit('updateUnread', response.data.unread);
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
         if (!store.state.tasks) {
           return null
         }
         for (let i = 0; i<store.state.tasks.length; i++) {
           if (store.state.tasks[i].id == id ) {
             return store.state.tasks[i]
           }
         }
         return null
      },
      filterList(search,path) {
            let ret = [];
            let paths = {};
            for (let key in store.state.list) {
              let val = store.state.list[key];
//              if (!val.title || (!all && !search && val.embedded)) continue;
              if (val.name == 'new') continue;
              if (!search && !((!val.path && !path) || val.path == path)) {
                if (!!val.path && (!path || val.path.startsWith( path + '/' ))) {
                  let name = val.path.substr(path.length)
                  if (name[0] == '/') {
                    name = name.substr(1)
                  }
                  let slash = name.indexOf("/")
                  if (slash > 0) {
                    name = name.substr(0, slash)
                  }
                  paths[name] = !!paths[name] ? paths[name] + 1 : 1; 
                }
                continue
              }
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
            for (let key in paths) {
              ret.push({
                group: true,
                title: key,
                desc: '%folder% (' + String(paths[key]) + `)`,
                weigth: 0,
              }) 
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
          this.socket.onclose = () => {/*this.connect()*/}
        },
        wsCmd({data}) {
          let cmd = JSON.parse(data);
          switch (cmd.cmd) {
           case WcStatus:
            let list = store.state.tasks
            if (!list) {
               return 
            }
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
            break
          case WcNotify:
            let notify = JSON.parse(cmd.message)
            if (!notify.error) {
              store.commit('updateNfy', notify.list);
              store.commit('updateUnread', notify.unread);
            }
            break
          }
        },
        favShift(shift) {
          const favlist = this.$refs.favlist
          const scrollPos = favlist.scrollLeft;
          shift = shift * favlist.clientWidth*3/4
          if (shift < 0) {
             favlist.scrollLeft = Math.max(0, scrollPos + shift)
          } else {
             favlist.scrollLeft = Math.min(favlist.scrollWidth-favlist.clientWidth+32, scrollPos + shift)
          }
          this.favButtons()
        },
        favButtons() {
          const favlist = this.$refs.favlist
          this.leftfav = favlist.scrollLeft>0
          this.rightfav = favlist.scrollLeft + favlist.clientWidth < favlist.scrollWidth
        },
    },
    mounted() {
      this.loadTasks()
      this.connect()
      setTimeout(this.favButtons, 1000)
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
        { id: 4, title: '%notifications%', icon: 'fa-bell', route: '/notifications' },
        { id: 5, title: '%settings%', icon: 'fa-tools', route: '/settings' },
        { id: 6, title: '%help%', icon: 'fa-life-ring', route: '/help' },
//        { id: 3, title: 'Support', icon: 'fa-life-ring' },
      ],
      menus: [
        { title: '%refresh%', icon: "fa-redo-alt", onclick: this.reload, 
             hide: [[not .Develop]]},
        { title: '%logout%', icon: "fa-sign-out-alt", onclick: this.logout, 
             hide: [[not .Login]]},
        { title: '%shutdown%', icon: "fa-power-off", 
          onclick: () => this.confirm("%exitconfirm%", this.exit), hide: [[.Playground]] },
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
      leftfav: false,
      rightfav: false,
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

