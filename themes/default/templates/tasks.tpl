<script type="text/x-template" id="tasks">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;">
      <v-btn @click="refreshtasks" color="primary" class="mt-4 ml-8">
          <v-icon small>fa-sync-alt</v-icon>&nbsp;{{refresh}}</v-btn>
      <table class="table" cellspacing="0">
        <tr><th v-for="item in heads">{{item}}</th></tr>
        <tr v-for="task in list">
          <td>{{task.name}}</td>
         <td>{{task.user}}@{{task.role}}</td>
          <td class="tdcenter"><v-chip
        class="mx-2 my-1 font-weight-bold px-5"
        :color="statusColor[task.status]"
        :text-color="task.status == stFinished ? '#616161' : '#fff'"
      >{{statusList[task.status]}}</v-chip></td>
          <td>{{task.start}}</td>
          <td>{{task.finish}}</td>
          <td><span class="mr-2">
              <v-icon color="primary" small @click="view(task.id)">fa-eye</v-icon></span>
              <span class="mr-2" v-show="task.status < stSuspended">
              <v-icon color="primary" small @click="pause(task.id)">fa-pause</v-icon></span>
              <span class="mr-2" v-show="task.status == stSuspended">
              <v-icon color="primary" small @click="resume(task.id)">fa-play</v-icon></span>
              <span class="mr-2" v-show="task.status == stSuspended">
              <v-icon color="primary" small @click="terminate(task.id)">fa-times</v-icon></span>
              <span class="mr-2" v-show="task.status >= stFinished && task.todel">
              <v-icon color="primary" small @click="remove(task.id)">fa-times</v-icon></span>
          </td>
        </tr>
      </table>
      <v-pagination v-model="page" :length="allpages" v-if="allpages>1"
      ></v-pagination>
    </div>
  </v-container>
</script>

<script>
const Tasks = {
  template: '#tasks',
  data: tasksData,
  methods: {
    syscmd(cmd, id) {
        let task = this.$root.getTask(id)
        if (!task) {
          return
        }
        axios
        .get(`/api/sys?cmd=${cmd}&taskid=${id}`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
        })
        .catch(error => this.$root.errmsg(error));
    },
    pause(id) {
      this.syscmd(SysSuspend, id)
    },
    resume(id) {
      this.syscmd(SysResume, id)
    },
    terminate(id) {
      this.$root.confirmYes( '%stopscript%', () => this.syscmd(SysTerminate, id))
    },
    view(id) {
      let task = this.$root.getTask(id)
      if (!task) {
        return
      }
      if (task.status < stFinished ) {
        window.open(window.location.protocol + '//' + window.location.hostname + ':' + task.port, '_blank');
      } else {
        window.open('/task/'+task.id, '_blank');
      }
    },
    setpage(page, allpages) {
      this.page = page
      this.allpages = allpages
    },
    remove(id) {
      let req = '/api/remove/' + id
      if (this.page != 1) {
        req += '?page=' + this.page;
      }
      axios
      .get(req)
      .then(response => {
        if (response.data.error) {
          this.$root.errmsg(response.data.error);
          return
        }
        store.commit('updateTasks', response.data.list);
        this.setpage(response.data.page, response.data.allpages)
      })
      .catch(error => this.$root.errmsg(error));
    },
    refreshtasks() {
      this.$root.loadTasks(this.page, this.setpage)
    },
  },
  watch: {
    page(newval) {
      this.$root.loadTasks(newval, this.setpage)
    }
  },
  computed: {
    list: function() { return store.state.tasks },
    refresh: function() { return '%refresh%' + ( store.state.newtasks ? 
                  `  (+${store.state.newtasks})` : '' )}
  },
  mounted() {
    store.commit('updateTitle', '%taskmanager%');
    store.commit('updateHelp', '%urltaskmanager%');
    this.$root.loadTasks(this.page, this.setpage)
  }
};

function tasksData() {
    return {
      page: 1,
      allpages: 1,
      heads: [ '%script%','%startedby%','%status%', '%start%', '%finish%', 
            '%actions%',

      ]
    }
}
</script>
