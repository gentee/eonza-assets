<script type="text/x-template" id="tasks">
  <v-container style="height:100%;">
    <div style="height:calc(100% - 0px);overflow-y: auto;">
      <table class="table" cellspacing="0">
        <tr><th v-for="item in heads">{{item}}</th></tr>
        <tr v-for="task in list">
          <td>{{task.name}}</td>
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
              <span class="mr-2" v-show="task.status >= stFinished">
              <v-icon color="primary" small @click="remove(task.id)">fa-times</v-icon></span>
          </td>
        </tr>
      </table>
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
      this.$root.confirmYes( [[lang "stopscript"]], () => this.syscmd(SysTerminate, id))
    },
    view(id) {
      let task = this.$root.getTask(id)
      if (!task) {
        return
      }
      if (task.status < stFinished ) {
        window.open('http://localhost:' + task.port, '_blank');
      } else {
        window.open('/task/'+task.id, '_blank');
      }
    },
    remove(id) {
      axios
      .get('/api/remove/' + id)
      .then(response => {
        if (response.data.error) {
          this.$root.errmsg(response.data.error);
          return
        }
        store.commit('updateTasks', response.data.list);
      })
      .catch(error => this.$root.errmsg(error));
    },
  },
  computed: {
    list: function() { return store.state.tasks },
  },
  mounted() {
    store.commit('updateTitle', [[lang "taskmanager"]]);
    this.$root.loadTasks()
  }
};

function tasksData() {
    return {
      heads: [ [[lang "name"]], [[lang "status"]], [[lang "start"]], [[lang "finish"]], 
            [[lang "actions"]],

      ]
    }
}
</script>
