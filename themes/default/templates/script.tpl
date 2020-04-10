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
</head>
<body>
<div id = "app">
  <v-app style="height:100%;">
      <v-app-bar app color="blue darken-1" dense dark>
        <v-toolbar-title>[[ .App.Title ]]</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-chip
        class="ma-2 font-weight-bold px-6"
        :color="statusColor[status]"
        :text-color="status == stFinished ? '#616161' : '#fff'"
      >
      <v-icon left class="pr-1" v-if="!!statusIcon[status]">{{statusIcon[status]}}</v-icon>
      {{statusList[status]}}
    </v-chip>
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
        <v-spacer></v-spacer>
      </v-app-bar>
    <v-content app style="height:100%;">
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
     <div id="output"></div>
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
 /*
     ws.onmessage = function(evt) {
      var out = document.getElementById('output');
      out.innerHTML += evt.data + '<br>';
    }
    ws.send('Hello, Server!');
*/

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
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
        .get('/sys?cmd=' + id)
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
        if (cmd.cmd == 1) {
          this.status = cmd.status;
        }
        if (cmd.message) {
          this.message = cmd.message
        }
        console.log( 'cmd', cmd, cmd.cmd, this.status );
      },
      connect() {
        this.socket = new WebSocket(wsUri())
        console.log(wsUri())
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
      this.connect();
    },
    computed: {
    }
})

function appData() { 
    return {
      develop: [[.Develop]],
      menus: [
        { title: [[lang "refresh"]], icon: "fa-redo-alt", onclick: this.reload, 
             hide: [[not .Develop]]},
        { title: [[lang "exit"]], icon: "fa-power-off", 
          onclick: () => this.confirm([[lang "exitconfirm"]], this.exit) },
      ],
      status: 0,
      message: '',

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