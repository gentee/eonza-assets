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
        </tr>
      </table>
    </div>
  </v-container>
</script>

<script>
const Tasks = {
  template: '#tasks',
  data: tasksData,
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
