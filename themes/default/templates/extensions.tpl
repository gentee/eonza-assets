<script type="text/x-template" id="extensions">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
        <v-alert v-for="(item,i) in list" border="left" colored-border
          :color="i < unread ? 'blue darken-1' : 'blue lighten-4'" elevation="2">
      <div style="color: #333;" v-html="item.text"></div>
      <div style="text-align: right">
         <span style="font-size:smaller;color: #777;font-style: italic">{{item.script}} {{item.user}}@{{item.role}} {{item.time}}</span> <v-btn icon small @click="remove(item.hash)" v-show="item.todel"><v-icon small color="blue">fa-trash-alt</v-icon></v-btn>
      </div>
      </v-alert>
    </div>
  </v-container>
</script>

<script>
const ext = {
  list: [ [[range .Nfy.List]]
    {text: '[[.Text]]', time: '[[.Time]]', todel: [[.ToDel]], script: '[[.Script]]'},
  [[end]] ]
}

const Extensions = {
  template: '#extensions',
  data: extensionsData,
  methods: {
/*    remove(id) {
      axios
      .get('/api/removeext/' + id)
      .then(response => {
        if (response.data.error) {
          this.$root.errmsg(response.data.error);
          return
        }
      })
      .catch(error => this.$root.errmsg(error));
    },*/
  },
  computed: {
    list: function() { return store.state.ext },
  },
  mounted() {
    store.commit('updateTitle', '%extensions%');
    store.commit('updateHelp', '%urlextensions%');
    //this.$root.loadExt()
  }
};

function extensionsData() {
    return {
    }
}
</script>
