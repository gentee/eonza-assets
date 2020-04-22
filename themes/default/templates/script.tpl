<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .Title ]]</title>
  <link rel="icon" href="/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <link rel="stylesheet" href="/css/fontawesome.min.css">
  <link rel="stylesheet" href="/css/eonza.css">
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
            <v-icon small left>fa-pause</v-icon>&nbsp;Suspend
        </v-btn>
        <v-btn v-if="status == stSuspended" color="primary" class="white font-weight-bold mx-2" outlined @click="syscommand(2)">
            <v-icon small left>fa-play</v-icon>&nbsp;Resume
        </v-btn>
        <v-btn v-if="status < stFinished" color="primary" class="white mx-2 font-weight-bold" 
        outlined @click="stop()">
            <v-icon small left>fa-times</v-icon>&nbsp;Break
        </v-btn>
    [[end]]
        <v-spacer></v-spacer>
      </v-app-bar>
    <v-content app style="height:100%;">
    <v-tabs v-model="tab">
        <v-tab>[[lang "info"]]</v-tab>
        <v-tab v-show="isform">[[lang "form"]]</v-tab>
        <v-tab v-show="isconsole">[[lang "console"]]</v-tab>
        <v-tab v-show="islog">[[lang "log"]]</v-tab>
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
    >[[lang "scriptterm"]]
    </v-alert>
    <v-alert
      prominent v-if="status == stCrashed"
      color="brown darken-2" dark
      icon="fa-bug"
    >[[lang "scriptcrash"]]
    </v-alert>

        <div v-show="tab==0">
          <table class="table">
          <tr><td>ID:</td><td>[[.ID]]</td></tr>
          <tr><td>[[lang "name"]]:</td><td>[[.Name]]</td></tr>
          <tr><td>[[lang "status"]]: </td><td>{{statusList[status]}}</td></tr>
          <tr><td>[[lang "start"]]: </td><td>{{start}}</td></tr>
          <tr><td>[[lang "finish"]]: </td><td>{{finish}}</td></tr>
          </table>
        </div>
        <div v-show="tab==1">
          Form
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
          Log
        </div>
      </div>
    </v-content>
    <dlg-question :show="question" :title="asktitle" v-on:btn="cmd"></dlg-question>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
  </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vue-router.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>
<!--script src="/js/vuex.min.js"></script-->

[[template "dialogs"]]

<script>

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
        this.confirm([[lang "stopscript"]], (par) => {
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
            if (!this.isconsole) {
              this.isconsole = true
            }
            let shouldScroll = this.console.scrollTop + 
                  this.console.clientHeight === this.console.scrollHeight;
            stdout.innerHTML += cmd.message + '<br>';
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
            }
            this.stdcur.innerHTML = cmd.message;
            break
        }
      },
      connect() {
        this.socket = new WebSocket(wsUri())
        this.socket.onopen = () => {};
        this.socket.onmessage = this.wsCmd
        this.socket.onclose = () => {}
      },
      errmsg( title ) {
        this.errtitle = title;
        this.error = true;
      },
/*      exit( par ) {
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
      },*/
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
      message: '',
      tab: [[if len .Stdout]]2[[else]]0[[end]],
      cmdline: '',
      start: [[.Start]],
      finish: [[.Finish]],
      stdout: null,
      console: null,
      stdcur: null,
      isform: false,
      isconsole: [[if len .Stdout]]true[[else]]false[[end]],
      islog: false,

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