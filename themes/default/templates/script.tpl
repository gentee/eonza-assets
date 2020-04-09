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
        <v-text class="mx-4 px-4" style="font-weight: bold"
         :style="{'background-color': statusColor[status], 'color': status == stFinished ? '#000' : '#fff'}">{{statusList[status]}}</v-text>
        <v-btn v-if="status < stSuspended" color="primary" class="white mx-2 font-weight-bold" outlined >
            <v-icon small left>fa-pause</v-icon>&nbsp;Suspend
        </v-btn>
        <v-btn v-if="status == stSuspended" color="primary" class="white font-weight-bold mx-2" outlined >
            <v-icon small left>fa-play</v-icon>&nbsp;Resume
        </v-btn>
        <v-btn v-if="status < stFinished" color="primary" class="white mx-2 font-weight-bold" outlined >
            <v-icon small left>fa-times</v-icon>&nbsp;Break
        </v-btn>
        <v-spacer></v-spacer>
      </v-app-bar>
    <v-content app style="height:100%;">
     <div id="output"></div>
    </v-content>
    <dlg-question :show="question" :title="asktitle" v-on:btn="cmd"></dlg-question>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
  </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vue-router.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<!--script src="/js/axios.min.js"></script>
<script src="/js/vuex.min.js"></script-->

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
 /*setTimeout(function() {
    ws = new WebSocket(uri)

    ws.onopen = function() {
      console.log('Connected')
    }

    ws.onclose = function() {
      console.log('Closed')
    }

    ws.onmessage = function(evt) {
      var out = document.getElementById('output');
      out.innerHTML += evt.data + '<br>';
    }
}, 2000);
    setInterval(function() {
      ws.send('Hello, Server!');
    }, 1000);*/

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
      getCmd({data}) {
        console.log( 'cmd', data );
        let cmd = JSON.parse(data);
        if (cmd.cmd == 1) {
          this.status = cmd.status;
        }
        console.log( 'cmd', data, cmd, cmd.cmd, this.status );
      },
      connect() {
        this.socket = new WebSocket(wsUri())
        console.log(wsUri())
        this.socket.onopen = () => {
           this.status = 2;
           console.log('connected')
        };
        this.socket.onmessage = this.getCmd
          this.socket.onclose = function() {
             console.log('Closed')
          }
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
      getStatus() {
        return status[this.status]
      }
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