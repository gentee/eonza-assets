<script type="text/x-template" id="notifications">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
        <v-alert v-for="(item,i) in list" border="left" colored-border
          color="deep-purple accent-4" elevation="2">
      <div style="color: #333;">{{item.text}}</div>
      <div style="text-align: right">
         {{item.time}} <v-btn icon small><v-icon small>fa-times</v-icon></v-btn>
      </div>
      </v-alert>
      Unread = {{unread}}
    </div>
  </v-container>
</script>

<script>
const nfy = {
  unread: [[.Nfy.Unread]],
  list: [ [[range .Nfy.List]]
    {text: '[[.Text]]', time: '[[.Time]]'},
  [[end]] ]
}

const Notifications = {
  template: '#notifications',
  data: notificationsData,
  methods: {
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
    list: function() { return store.state.nfy },
    unread: function() { return store.state.unread },
  },
  mounted() {
    store.commit('updateTitle', '%notifications%');
    store.commit('updateHelp', '%urlnotifications%');
    this.$root.loadNfy()
  }
};

function notificationsData() {
    return {
    }
}
</script>
