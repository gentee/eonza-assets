<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .Title ]]</title>
  <link rel="icon" href="[[.CDN]]/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="[[.CDN]]/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="[[.CDN]]/css/vuetify.min.css">
  <link rel="stylesheet" href="[[.CDN]]/css/fontawesome.min.css">
  <link rel="stylesheet" href="[[.CDN]]/css/eonza.css">
</head>
<body>

<div id = "app">
  <v-app style="height:100%;">
      <v-app-bar app color="blue darken-1" dense dark>
        <v-toolbar-title>[[ .Title ]]</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-chip
        class="ma-2 font-weight-bold px-6"
        :color="statusColor[status]"
        :text-color="status == stFinished ? '#616161' : '#fff'"
      >
      <v-icon left class="pr-1" v-if="!!statusIcon[status]">{{statusIcon[status]}}</v-icon>
      {{statusList[status]}}
    </v-chip>
    [[if .IsScript]]
        <v-btn v-if="status < stSuspended" color="primary" class="white mx-2 font-weight-bold" outlined @click="syscommand(1)">
            <v-icon small left>fa-pause</v-icon>&nbsp;%suspend%
        </v-btn>
        <v-btn v-if="status == stSuspended" color="primary" class="white font-weight-bold mx-2" outlined @click="syscommand(2)">
            <v-icon small left>fa-play</v-icon>&nbsp;%resume%
        </v-btn>
        <v-btn v-if="status < stFinished" color="primary" class="white mx-2 font-weight-bold" 
        outlined @click="stop()">
            <v-icon small left>fa-times</v-icon>&nbsp;%break%
        </v-btn>
    [[end]]
        <v-spacer></v-spacer>
      </v-app-bar>
    <v-content app style="height:100%;">
    <div v-show="!!progress">
       <div v-for="prog in progress" class="prog">
           {{prog.source}} 
           <v-progress-linear v-model="prog.percent" color="success" style="max-width: 600px;"></v-progress-linear>
           {{prog.current}} / {{prog.total}} {{prog.remain}}
       </div>
    </div>
    <v-tabs v-model="tab">
        <v-tab>%info%</v-tab>
        <v-tab v-show="isform > 0">%form%</v-tab>
        <v-tab v-show="isconsole">%console%</v-tab>
        <v-tab v-show="islog">%log%</v-tab>
        <v-tab v-show="issrc">%sourcecode%</v-tab>
    </v-tabs>
      <div style="height:calc(100% - 48px);overflow-y:auto;" id="console">
    <v-alert
      prominent v-if="status == stFailed"
      type="error"
    >{{message}}
    </v-alert>
    <v-alert
      prominent v-if="status == stTerminated"
      color="blue-grey darken-3" dark
      icon="fa-thumbs-down"
    >%scriptterm%
    </v-alert>
    <v-alert
      prominent v-if="status == stCrashed"
      color="brown darken-2" dark
      icon="fa-bug"
    >%scriptcrash%
    </v-alert>

        <div v-show="tab==0">
          <table class="table">
          <tr><td>ID:</td><td>[[.ID]]</td></tr>
          <tr><td>%name%:</td><td>[[.Name]]</td></tr>
          <tr><td>%status%: </td><td>{{statusList[status]}}</td></tr>
          <tr><td>%start%: </td><td>{{start}}</td></tr>
          <tr><td>%finish%: </td><td>{{finish}}</td></tr>
          </table>
        </div>
        <div v-show="tab==1">
         <div class="pl-6" style="max-height: 100%;overflow-y: auto;max-width: 1024px;">
            <component v-for="comp in fields" v-on:btnclick="btnclick($event)"
               :is="PTypes[comp.type].comp" v-bind="{par:comp, vals:values}"></component>
            <v-btn v-show="iscontinue" color="primary" style="text-transform:none"
               class="ma-2 white--text" @click="sendform">%continue%</v-btn>
          </div>
        </div>
        <div v-show="tab==2">
          <div class="console" id="stdout">[[.Stdout]]
          </div>
        <div class="console" id="stdcur">
        </div>
       [[if .IsScript]]
        <div v-if="status < stFinished" style="padding: 0px 16px;background-color: #444;" class="d-flex justify-start align-baseline">
        <v-text-field class="console" 
           style="max-width: 1024px;"
            label="standard input"
            color="white" v-on:keyup="validateCmdLine"
            v-model= "cmdline"
            dark dense single-line outlined
          ></v-text-field> <v-btn
      :disabled="!cmdline"
      color="primary"
      style="text-transform:none"
      class="ma-2 white--text"
      @click="enterconsole"
    >
      <v-icon small left dark>fa-paper-plane</v-icon>
       Enter
    </v-btn></div>
        [[end]]
        </div>
        <div v-show="tab==3">
          <div class="console" id="logout">[[.Logout]]
          </div>
        </div>
        <div v-show="tab==4">
          [[.Source]]
        </div>
      </div>
    </v-content>
    <dlg-question :show="question" :title="asktitle" v-on:btn="cmd"></dlg-question>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
  </v-app>
</div>
<script src="[[.CDN]]/js/vue.min.js"></script>
<script src="[[.CDN]]/js/vue-router.min.js"></script>
<script src="[[.CDN]]/js/vuetify.min.js"></script>
<script src="[[.CDN]]/js/axios.min.js"></script>
<!--script src="/js/vuex.min.js"></script-->

<script>
const changed = {
  methods: {
    change() {
    },
  },
  computed: {
/*    active: {
        get() { return store.state.active },
        set(value) { store.commit('updateActive', value) }
    },*/
    changed: {
        get() { return false },
        set(value) { }
    },
  }
}
</script>

[[template "dialogs"]]
[[template "dyncomp" .]]

<script>

function escapeHTML(input) {
  return input.replace(/[&<>"']/g, function(ch) {
    switch (ch) {
      case '&':
        return '&amp;';
      case '<':
        return '&lt;';
      case '>':
        return '&gt;';
      case '"':
        return '&quot;';
      default:
        return '&#039;';
    }
  });
}

function log2color(input) {
  let color = {'INFO': 'egreen', 'FORM': 'eblue', 'WARN': 'eyellow', 'ERROR': 'ered'}
  for (let key in color) {
    if (color.hasOwnProperty(key)) {
      input = input.replace("["+key+"]", '<span class="'+color[key]+'">[' + key+ ']</span>');
    }
  }
  return input
}

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
      enterconsole() {
        axios
        .post(`/stdin?taskid=${ [[.ID]] }`,{message: this.cmdline})
        .then(response => {
           if (response.data.error) {
             this.errmsg(response.data.error);
              return
            }
            this.cmdline = '';
         })
         .catch(error => this.errmsg(error));
      },
      btnclick(btn) {
         this.sendform(btn)
      },
      sendform(btn) {
        for (let i = 0; i < this.form.length; i++) {
            let item = this.form[i]
            if (!!item.options.required && ( item.type == PTextarea  ||
                item.type == PSingleText ||  item.type == PNumber || item.type == PPassword) && 
                this.values[item.var] == '') {
              this.$root.errmsg(format("%errreq%", item.text))
              return
            }
            if ( item.type == PHTMLText ) {
              delete this.values[item.var]
            }
            if ( item.type == PButton ) {
              if (!btn || btn.name != item.var) {
                delete this.values[item.var]
              } else {
                this.values[item.var] = btn.value
              }
            }
        }

        axios
        .post(`/form?taskid=${ [[.ID]] }`,{formid: this.formid, values: this.values})
        .then(response => {
           if (response.data.error) {
             this.errmsg(response.data.error);
              return
            }
            this.isform--
            if (!this.isform) {
              this.tab = 0
            }
         })
         .catch(error => this.errmsg(error));
      },
      validateCmdLine: function(e) {
        if (e.keyCode === 13) {
          this.enterconsole()
        }      
      },
      stop() {
        let restore = false
        if (this.status != stSuspended) {
          this.syscommand(1)
          restore = true
        }
        this.confirm("%stopscript%", (par) => {
          this.question = false;
          if (par == btn.Yes) {
            this.syscommand(3)
          } else if (restore) {
            this.syscommand(2)
          }
        })
      },
      syscommand(id) {
        axios
        .get(`/sys?cmd=${id}&taskid=${ [[.ID]] }`)
        .then(response => {
            if (response.data.error) {
                this.errmsg(response.data.error);
                return
            }
        })
        .catch(error => this.errmsg(error));
      },
      wsCmd({data}) {
        let cmd = JSON.parse(data);
        switch (cmd.cmd) {
          case WcStatus:
            this.status = cmd.status;
            if (cmd.message) {
              this.message = cmd.message
            }
            if (cmd.finish) {
              this.finish = cmd.finish
            }
            break
          case WcStdout:
            if (!cmd.message) {
              cmd.message = '&nbsp;';
            }
            if (!this.isconsole) {
              this.isconsole = true
            }
            let shouldScroll = this.console.scrollTop + 
                  this.console.clientHeight === this.console.scrollHeight;
            stdout.innerHTML += escapeHTML(cmd.message) + '<br>';
            if (shouldScroll) {
              this.console.scrollTop = this.console.scrollHeight;
            }
            this.stdcur.innerHTML = '&nbsp;'
            if (this.tab==0) {
              this.tab = 2
            }
            break
          case WcStdbuf:
            if (!cmd.message) {
              cmd.message = '&nbsp;';
            } else {
              cmd.message = escapeHTML(cmd.message)
            }
            this.stdcur.innerHTML = cmd.message;
            break
          case WcLogout:
            if (!this.islog) {
              this.islog = true
            }
            let shouldLogScroll = this.console.scrollTop + 
                  this.console.clientHeight === this.console.scrollHeight;
            logout.innerHTML += log2color(cmd.message) + '<br>';
            if (shouldLogScroll) {
              this.console.scrollTop = this.console.scrollHeight;
            }
            if (this.tab==0) {
              this.tab = 3
            }
            break
          case WcForm:
            this.isform++
            this.form = JSON.parse(cmd.message) 
            this.formid = cmd.status || 0
            this.fields = []
            this.values = {}
            for (let i = 0; i < this.form.length; i++) {
              let item = this.form[i]
              if (!!item.options) {
                if (typeof item.options === 'string') {
                  item.options = JSON.parse(item.options)  
                }
              } else {
                item.options = {}
              }
              this.fields.push({name: item.var, type: item.type, title: item.text, 
                  options: item.options})
              let value = item.value || '' 
              if (item.type == PCheckbox) {
                value = value != '0' && value != 'false' && !!value
              }
              this.$set(this.values, item.var, value)
            }
            this.iscontinue = this.form.length == 0 || this.form[this.form.length-1].type != PButton
            this.tab = 1
            break         
          case WcProgress:
            let prog = JSON.parse(cmd.message)
            let i = 0
            if (prog.remain) {
              prog.remain = '%remaintime%: ' + prog.remain
            }
            switch (prog.type) {
              case 0: // copy
                prog.source = format('%copyfile%', prog.source, prog.dest)
                break;
              case 1: // download
                prog.source = format('%downloadfile%', prog.source, prog.dest)
                break;
            }
            for (; i < this.progress.length; i++) {
              if (this.progress[i].id == prog.id) {
                this.$set(this.progress, i, prog)
                break
              }
            }
            if (prog.percent < 100) {
              if (i >= this.progress.length) {
                this.progress.push(prog)
              }
            } else if ( i < this.progress.length ) {
              this.progress.splice(i, 1)
            }
            break   
        }
      },
      connect() {
        this.socket = new WebSocket(wsUri())
        this.socket.onopen = () => {};
        this.socket.onmessage = this.wsCmd
        this.socket.onclose = () => {/*this.connect()*/}
      },
      errmsg( title ) {
        this.errtitle = title;
        this.error = true;
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
    },
    mounted() {
      this.stdout = document.getElementById("stdout")
      this.console = document.getElementById("console")
      this.stdcur = document.getElementById("stdcur")
      this.logout = document.getElementById("logout")
      [[if .IsScript]]
         this.connect();
      [[end]]
    },
    computed: {
    }
})

function appData() { 
    return {
      status: [[.Task.Status]],
      message: [[.Task.Message]],
      tab: [[if len .Stdout]]2[[else]][[if len .Logout]]3[[else]]0[[end]][[end]],
      cmdline: '',
      start: [[.Start]],
      finish: [[.Finish]],
      stdout: null,
      console: null,
      logout: null,      
      stdcur: null,
      isform: 0,
      iscontinue: true,
      isconsole: [[if len .Stdout]]true[[else]]false[[end]],
      islog: [[if len .Logout]]true[[else]]false[[end]],
      issrc: [[if len .Source]]true[[else]]false[[end]],
      form: [],
      formid: -1,
      fields: [],
      values: {},
      progress: [],

      cmd: null,
      question: false,
      asktitle: "",
      error: false,
      errtitle: '',
    }
}

</script>

</body>
</html>