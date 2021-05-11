<script type="text/x-template" id="dlg-upload">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <div>

      <v-card>
        <v-card-title classx="py-4">
        <div style="width: 100%;">
          <div class="pb-3">{{title}}</div>
          <v-cloak @drop.prevent="addDropFile" @dragover.prevent>
          <v-file-input chips multiple label="%selectupload%" v-model="files"></v-file-input>
          </v-cloak>
          <v-checkbox v-model="overwrite" label="%overwrite%"></v-checkbox>
        </div>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" :disabled="!files.length"
            @click="click(btn.OK)"  class="ma-2"
          >
            %upload%
          </v-btn>
          <v-btn
            color="primary" outlined
            @click="click(btn.Cancel)"  class="ma-2"
          >
            %cancel%
          </v-btn>

        </v-card-actions>
      </v-card>

      </div>
    </v-dialog>
</script>

<script>

Vue.component('dlg-upload', {
    template: '#dlg-upload',
    props: ['show', 'title'],
    data() {
       return {
         overwrite: false,
         files: [],
       }
    },
    methods: {
        addDropFile(e) {
          this.files = Array.from(e.dataTransfer.files);
        },
        click: function (par) {
            this.$emit('btn', {btn: par, files: this.files, overwrite: this.overwrite});
        },
       keyProcess: function(event) {
            switch (event.keyCode) {
                case 13:
                case 32: 
                  if (this.files.length) {
                   this.click(btn.OK);

                  }
                  break;
                case 27: 
                   this.click(btn.Cancel);
                   break;
            }
        }
    },
    watch: {
        show(newval) {
            if (newval) {
                this.files = []
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});
</script>

<script type="text/x-template" id="dlg-question">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <div>

      <v-card>
        <v-card-title classx="py-4">
        <div style="width: 100%;">
        <v-icon size="2em" color="blue darken-2" class="mr-4 my-4" style="float: left;">fa-question-circle
        </v-icon>
          <div  class="wordbreak">{{title}}</div>
        </div>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary"
            @click="click(btn.Yes)"  class="ma-2"
          >
            %yes%
          </v-btn>
          <v-btn
            color="primary" outlined
            @click="click(btn.No)"  class="ma-2"
          >
            %no%
          </v-btn>

        </v-card-actions>
      </v-card>

      </div>
    </v-dialog>
</script>

<script>
const btn = {
    No: 0,
    Yes: 1,
    OK: 2,
    Cancel: 3,
}

Vue.component('dlg-question', {
    template: '#dlg-question',
    props: ['show', 'title'],
    methods: {
        click: function (par) {
            this.$emit('btn', par);
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
                case 13:
                case 32: 
                   this.click(btn.Yes);
                   break;
                case 27: 
                   this.click(btn.No);
                   break;
            }
        }
    },
    watch: {
        show(newval) {
            if (newval) {
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});

</script>

<script type="text/x-template" id="dlg-error">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <v-card>
        <v-card-title classx="py-4">
        <div style="width: 100%;">
          <v-icon size="2em" color="error" class="mr-4 my-4" style="float: left;">fa-times-circle
          </v-icon><div class="wordbreak">{{title}}</div>
        </div>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn v-if="callback"
            color="primary" style="text-transform: none;"
            @click="callbackfn()"  class="ma-2 white--text"
          >
            {{callback.title}}
          </v-btn>

          <v-btn
            color="orange darken-3" 
            @click="close()"  class="ma-2 white--text"
          >
            %ok%
          </v-btn>

        </v-card-actions>
      </v-card>
    </v-dialog>
</script>

<script>
Vue.component('dlg-error', {
    template: '#dlg-error',
    props: ['show', 'title', 'callback'],
    methods: {
        callbackfn() {
          this.$emit('close');
          this.callback.func();
        },
        close: function () {
            this.$emit('close');
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
                case 13:
                case 32: 
                case 27: 
                   this.close();
                   break;
            }
        }
    },
    watch: {
        show(newval) {
            if (newval) {
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});

</script>

<script type="text/x-template" id="dlg-commands">
    <v-dialog v-model="show" max-width="700" persistent = true scrollable>
      <v-card>
        <v-card-title>%selcmd%</v-card-title>
        <v-divider></v-divider>
        <div class="d-flex pt-4 px-2">
          <v-text-field class="mx-2" append-icon="fa-search" v-model="search" 
            label="%search%"
            outlined @input="tosearch"
          ></v-text-field>
          <v-btn @click="clearsearch" class="mt-3" icon color="primary" v-if="!!search">
            <v-icon>fa-times</v-icon>
          </v-btn>
        </div>
        <v-breadcrumbs :items="breads" large v-show="!search" class="pt-0 pl-4 pb-1">
          <template v-slot:item="{ item }">
          <v-breadcrumbs-item href="#" @click="return folder('/' + item.path)":disabled="item.disabled">
            {{item.text}}
          </v-breadcrumbs-item>
          </template>
        </v-breadcrumbs>
        <v-card-text style="height: 360px;">
         <div  class="d-flex flex-wrap" style="margin-right: 2px;">
            <v-card style="border-left: 2px solid #f00;" :color="item.group ? '#FFF9C4' : 'white'"
              v-for="(item, i) in curlist"
              :key="i" style="max-width: 350px;" @click="selectScript(item)"
              class="flex-grow-1 ma-2 pa-2 d-flex flex-column justify-space-between"
            > 
              <div style="font-weight: bold;"><v-icon color="primary" v-if="!item.group">fa-check-square</v-icon>
              <v-icon color="primary" v-if="item.group">fa-folder-open</v-icon>&nbsp;{{item.title}}
              </div>
              <div>{{desc(item)}}</div>
            </v-card>
          </div>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="primary" outlined
            @click="close('')"  class="ma-2"
          >
            %cancel%
          </v-btn>

        </v-card-actions>
      </v-card>
    </v-dialog>
</script>

<script>
Vue.component('dlg-commands', {
    template: '#dlg-commands',
    props: ['show'],
    data: dlgCommandsData,
    methods: {
        folder(name) {
          let ret = getBreads(name, this.path)
          this.path = ret.path
          this.breads = ret.breads
          return false
        },
        clearsearch() {
          this.search = '';
          //this.$forceUpdate();
          this.curlist;
        },
        tosearch() {
          if (this.search.length != 1) {
            this.curlist;
//          this.$forceUpdate();
          }
        },
        selectScript(item) {
          if (item.group) {
            this.folder(item.title)
          } else {
            this.close(item.name)
          }
        },
        close: function (par) {
            this.$emit('cmdname', par)
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
//                case 13:
//                case 32: 
                case 27: 
                   this.close('');
                   break;
            }
        }
    },
    computed: {
      list: function() { return store.state.list },
      curlist: function() { return this.$root.filterList(this.search, this.path) },
    },
    mounted() {
      this.$root.loadList(this.viewlist);
    },
    watch: {
        show(newval) {
            if (newval) {
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});

function dlgCommandsData() {
    return {
        search: '',
        path: '',
        breads: getBreads('','').breads,
    }
}

const stActive = 1
const stWaiting = 2
const stSuspended = 3
const stFinished = 4
const stTerminated = 5
const stFailed = 6
const stCrashed = 7

const statusList = [
    '', '%active%', '%waiting%', '%suspended%',
    '%finished%', '%terminated%', '%failed%', '%crashed%',
 ]
const statusColor = [
    '#fff', '#4CAF50', '#0277BD', '#EF6C00',
    '#fff', '#37474F', '#F44336', '#5D4037',
 ]
const statusIcon = [
    '', '', '', '',
    'fa-flag-checkered', 'fa-thumbs-down', 'fa-exclamation-triangle', 'fa-bug'
 ]

const WcStatus = 1
const WcStdout = 2
const WcStdbuf = 3
const WcLogout = 4
const WcForm = 5
const WcProgress = 6
const WcNotify = 7
const WcReport = 8

const SysSuspend = 1
const SysResume = 2
const SysTerminate = 3

function wsUri() {
    let loc = window.location;
    let uri = 'ws:';
    if (loc.protocol === 'https:') {
      uri = 'wss:';
    }
    uri += '//' + loc.host;
    uri += loc.pathname + 'ws';
    return uri;
}

function format(pattern, par, par2) {
    let ret = pattern.replace('%s', par);
    if (par2) {
      ret = ret.replace('%s', par2); 
    }
    return ret
}

function getBreads(name, owner) {
  let path
  if (!name || name == '/') {
      breads = [{text: '%home%', disabled: true, path: ''}]
      path = ''
  } else {
      breads = [{text: '%home%', disabled: false, path: ''}]
      if (name[0] == '/') {
        path = name.substr(1)
      } else {
        path = (owner ? owner + '/' : '') + name
      }
      let paths = path.split('/')
      for (let i = 0; i < paths.length; i++) {
        let curpath = breads[i].path + (i > 0 ? '/' : '') + paths[i]
        breads.push({text: paths[i], disabled: i==paths.length-1, path: curpath})
      }
  }
  return {path: path, breads: breads}
}

</script>