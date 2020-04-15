<script type="text/x-template" id="tasks">
  <v-container style="height:100%;">
    <div style="height:calc(100% - 0px);">
         Task Manager
    </div>
  </v-container>
</script>

<script>
const Tasks = {
  template: '#tasks',
  data: tasksData,
  mounted() {
    store.commit('updateTitle', [[lang "taskmanager"]]);
  }
};

function tasksData() {
    return {
    }
}
</script>
