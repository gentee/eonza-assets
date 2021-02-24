<script type="text/x-template" id="notifications">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
        <v-alert v-for="(item,i) in list" border="left" colored-border
          :color="i < unread ? 'blue darken-1' : 'blue lighten-4'" elevation="2">
      <div style="color: #333;" v-html="item.text"></div>
      <div style="text-align: right">
         <span style="font-size:smaller;color: #777;font-style: italic">{{item.script}} {{item.user}} {{item.time}}</span> <v-btn icon small @click="remove(item.hash)" v-show="item.todel"><v-icon small color="blue">fa-trash-alt</v-icon></v-btn>
      </div>
      </v-alert>
    </div>
  </v-container>
</script>

<script>
const nfy = {
  unread: [[.Nfy.Unread]],
  list: [ [[range .Nfy.List]]
    {text: '[[.Text]]', time: '[[.Time]]', todel: [[.ToDel]], script: '[[.Script]]'},
  [[end]] ]
}

const Notifications = {
  template: '#notifications',
  data: notificationsData,
  methods: {
    remove(id) {
      axios
      .get('/api/removenfy/' + id)
      .then(response => {
        if (response.data.error) {
          this.$root.errmsg(response.data.error);
          return
        }
      })
      .catch(error => this.$root.errmsg(error));
    },
  },
  computed: {
    list: function() { return store.state.nfy },
  },
  mounted() {
    store.commit('updateTitle', '%notifications%');
    store.commit('updateHelp', '%urlnotifications%');
    this.$root.loadNfy()
    setTimeout(() => {
      this.unread = store.state.unread
      store.commit('updateUnread', 0)
    }, 1000)
  }
};

function notificationsData() {
    return {
      unread: 0,
    }
}
</script>
