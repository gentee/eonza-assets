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
        <v-tab v-show="isreport">%reports%</v-tab>
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
          <table class="table table2b">
          <tr><td>ID:</td><td>[[.ID]]</td></tr>
          <tr><td>%name%:</td><td>[[.Name]]</td></tr>
          <tr><td>%startedby%:</td><td>[[.Nickname]]@[[.Role]]</td></tr>
          <tr><td>%ipaddress%:</td><td>[[.IP]]</td></tr>
          <tr><td>%status%: </td><td>{{statusList[status]}}</td></tr>
          <tr><td>%start%: </td><td>{{start}}</td></tr>
          <tr><td>%finish%: </td><td>{{finish}}</td></tr>
          </table>
        </div>
        <div v-show="tab==1" [[if eq .FormAlign 1]]style="display:flex;justify-content: center;"[[end]]>
         <div class="pl-6" style="max-height: 100%;overflow-y: auto;max-width: 1024px;flex-grow:1">
            <component v-for="comp in fields" v-on:btnclick="btnclick($event)"
               :is="PTypes[comp.type].comp" v-bind="{par:comp, vals:values}"></component>
            <v-btn v-show="iscontinue" color="primary" style="text-transform:none"
               class="ma-2 white--text" @click="sendform">%continue%</v-btn>
            [[if .IsAutoFill]]
            <div class="mb-2" v-show="afvisible">
              <div style="display:inline-flex;align-items:center;">
                <v-checkbox v-model="afcheck" label="%saveform%"></v-checkbox>
                <v-btn class="ml-5" elevation="2" icon small color="primary" v-show="!afexpand"
                    @click="afexpand = true">
                    <v-icon small>fa-angle-down</v-icon>
                </v-btn>
                <v-btn class="ml-5" elevation="2" icon small color="primary" v-show="afexpand"
                   @click="afexpand = false">
                  <v-icon small>fa-angle-up</v-icon>
              </v-btn>
             </div>
               <div v-show="afexpand" style="max-width: 600px;">
                 <v-select outlined :items = "aflist" label="%fillas%" v-model="afcurlist" @change="changeFill" dense>
                </v-select>
                <v-text-field v-model="afname" label="%saveas%"></v-text-field>
              </div>
            </div>
            [[end]]
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
          <div id="reports" class="mt-4" style="position: relative">
          <v-tabs v-model="curReport" dark background-color="blue darken-3" show-arrows continuous>
          <v-tabs-slider color="blue lighten-3"></v-tabs-slider>
            <v-tab  v-for="(rep, i) in reportslist" :key="i" >
              {{rep.title}}
            </v-tab>
          </v-tabs>
          <div class="pa-4" v-show="curReport==i" v-for="(rep, i) in reportslist" v-html="rep.body" :key="i" >
          </div>
          <v-btn @click="savereport" color="primary" style="position:absolute;right: 3em;top: 6em;"><v-icon left small>fa-save</v-icon>&nbsp;%savefile%</v-btn>
          </div>
        </div>
        <div v-show="tab==5">
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
const Reports = [
  [[range .Reports]]
     {title: [[.Title]], body: [[.Body]]},
  [[end]]
];

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
      input = input.replaceAll("["+key+"]", '<span class="'+color[key]+'">[' + key+ ']</span>');
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
      savereport() {
        let url = `/api/savereport`
        [[if .IsScript]]
          if (this.status < stFinished) {
            url = `/savereport` 
          } else {
            url =  window.location.protocol + '//' + window.location.hostname + ':' + '[[.URLPort]]' + url
          }
        [[end]]
        window.location = url + `?taskid=${ [[.ID]] }&reportid=` + this.curReport
      },
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
        let skip = btn && btn.skip
        for (let i = 0; i < this.form.length; i++) {
            let item = this.form[i]
            if (!!item.options.required && !skip && ( item.type == PTextarea  ||
                item.type == PSingleText ||  item.type == PNumber || item.type == PPassword) && 
                this.values[item.var] == '') {
              this.$root.errmsg(format("%errreq%", item.text))
              return
            }
            if ( item.type == PHTMLText ) {
              delete this.values[item.var]
            }
            if ( item.type == PButton || item.type == PButtonLink ) {
              if (!btn || btn.name != item.var) {
                delete this.values[item.var]
              } else {
                this.values[item.var] = btn.value
              }
            }
            if (item.type == PCheckList) {
              this.values[item.var] = JSON.stringify(this.values[item.var])
            }
        }
        this.fields = []
        axios
        .post(`/form?taskid=${ [[.ID]] }`,{formid: this.formid, values: this.values, skip: skip})
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
      [[if .IsAutoFill]]
      if (this.afvisible) {
        let url =  window.location.protocol + '//' + window.location.hostname + ':' + 
            '[[.URLPort]]' + '/api/saveform';
        let afform = {
          _afcheck: this.afcheck,
          _name: this.afname
        }
        if (this.afcheck) {
         for (let i = 0; i < this.form.length; i++) {
            let item = this.form[i]
            if (item.type == PTextarea || item.type == PSingleText || item.type == PNumber ||
                item.type == PCheckbox || item.type == PSelect) {
                afform[item.var] = this.values[item.var]
            }
          }
        }
        axios.post(url, {taskid: [[.ID]], userid: [[.UserID]], ref: this.ref, form: afform})
        .then(response => {
           if (response.data.error) {
             this.errmsg(response.data.error);
              return
            }
         })
         .catch(error => this.errmsg(error));
      }
      [[end]]

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
      [[if .IsAutoFill]]
      changeFill() {
        this.afname = this.afcurlist
        for (let i = 0; i < this.autofill.length; i++) {
          if (this.autofill[i]._name == this.afcurlist) {
            for (let k = 0; k < this.afnames.length; k++)  {
              let name = this.afnames[k]
              if (this.autofill[i].hasOwnProperty(name)) {
                this.$set(this.values, name, this.autofill[i][name])
              }
            }
            break
          }
        }
      },
      getAutoFill() {
        this.aflist = []
        this.afname = ''
        let url =  window.location.protocol + '//' + window.location.hostname + ':' + 
            '[[.URLPort]]' + '/api/autofill'
        axios
        .post(url, {taskid: [[.ID]], userid: [[.UserID]], ref: this.ref})
        .then(response => {
           if (response.data.error) {
             this.errmsg(response.data.error);
              return
            }
            if (response.data.autofill) {
              this.autofill = response.data.autofill;
              if (this.autofill.length > 0) {
                let latest = this.autofill[0]
                let shift = 0
                this.afcheck = latest._afcheck
                if (this.afcheck) {
                    for (let i = 0; i < this.afnames.length; i++)  {
                      let name = this.afnames[i]
                      if (latest.hasOwnProperty(name)) {
                          this.$set(this.values, name, latest[name])
                      }
                    }
                  this.afname = this.autofill[0]._name
                  this.afcurlist = this.autofill[0]._name
                } else {
                  shift = 1
                }
                for (let i = shift; i < this.autofill.length; i++) {
                  this.aflist.push(this.autofill[i]._name)
                }
              }
            }
         })
         .catch(error => this.errmsg(error));
      },
      [[end]]
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
            stdout.innerHTML += escapeHTML(cmd.message).replace(/\n/g, "<br>" );
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
              if (!this.isconsole) {
                this.isconsole = true
              }
              cmd.message = escapeHTML(cmd.message)
              if (this.tab==0) {
                this.tab = 2
              }
            }
            this.stdcur.innerHTML = cmd.message;
            break
          case WcLogout:
            if (!this.islog) {
              this.islog = true
            }
            let shouldLogScroll = this.console.scrollTop + 
                  this.console.clientHeight === this.console.scrollHeight;
            logout.innerHTML += log2color(cmd.message).replace(/\n/g, "<br>" );
            if (shouldLogScroll) {
              this.console.scrollTop = this.console.scrollHeight;
            }
            if (this.tab==0) {
              this.tab = 3
            }
            break
          case WcForm:
            this.ref = cmd.ref || ''
            this.autoFill = []
            this.afcheck = false
            this.afvisible = false
            this.afexpand = false
            this.afnames = []
            this.isform++
            let formdata = JSON.parse(cmd.message) 
            this.form = formdata.list
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
              if (formdata.autofill && (item.type == PTextarea || item.type == PSingleText || 
                item.type == PNumber || item.type == PCheckbox || item.type == PSelect)) {
                  this.afnames.push(item.var)
                  this.afvisible = true
              }
            }
            this.iscontinue = this.form.length == 0 || this.form[this.form.length-1].type != PButton
            this.tab = 1
            [[if .IsAutoFill]]
            if (this.afvisible) {
               this.getAutoFill()
            }
            [[end]]
            break         
          case WcReport:
            let report = JSON.parse(cmd.message)
            if (!this.isreport) {
              this.isreport = true
            }
            this.reportslist.push(report)
            this.curReport = this.reportslist.length-1
            this.tab = 4
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
      this.reports = document.getElementById("reports")
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
      reports: null,
      isform: 0,
      iscontinue: true,
      isconsole: [[if len .Stdout]]true[[else]]false[[end]],
      islog: [[if len .Logout]]true[[else]]false[[end]],
      isreport: [[if len .Reports]]true[[else]]false[[end]],
      issrc: [[if len .Source]]true[[else]]false[[end]],
      form: [],
      formid: -1,
      fields: [],
      values: {},
      progress: [],
      reportslist: Reports,
      curReport: 0,
      afcheck: 0,
      afvisible: false,
      aflist: [],
      afcurlist: '',
      afname: '',
      afexpand: false,
      afnames: [],
      autoFill: [],
      ref: '',
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