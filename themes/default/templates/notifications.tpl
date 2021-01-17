<script type="text/x-template" id="notifications">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
        <v-alert v-for="(item,i) in list" border="left" colored-border
          color="deep-purple accent-4" elevation="2">
      <div style="color: #333;" v-html="item.text"></div>
      <div style="text-align: right">
         <span style="font-size:smaller;color: #777;font-style: italic">{{item.time}}</span> <v-btn icon small @click="remove(item.hash)"><v-icon small color="blue">fa-trash-alt</v-icon></v-btn>
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
