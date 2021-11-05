<script type="text/x-template" id="extensions">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
        <v-card v-for="(item,i) in list" elevation="2" class="mx-2" 
        :style="item.installed ? 'border-left: 8px solid #64DD17' : ''">
          <div style="display:inline-flex;width: 100%;">
      <div style="flex-grow: 1;">
        <v-card-title v-text="item.title"></v-card-title>
        <v-card-subtitle v-text="item.desc"></v-card-subtitle>
      </div>
      <div class="pa-4">
        <v-btn color="primary" xclick="remove(item.hash)" v-show="item.installed"
        ><v-icon small>fa-trash-alt</v-icon>&nbsp;%uninstall%</v-btn>
        <v-btn color="primary" xclick="remove(item.hash)" v-show="!item.installed"><v-icon small >fa-download</v-icon>&nbsp;%install%</v-btn>
    </div>
  </div>
      </v-card>
    </div>
  </v-container>
</script>

<script>
const Extensions = {
  template: '#extensions',
  data: extensionsData,
  methods: {
    loadExtensions() {
        axios
        .get('/api/extensions')
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.list = response.data.list
        })
        .catch(error => this.$root.errmsg(error));
      },
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
  mounted() {
    store.commit('updateTitle', '%extensions%');
    store.commit('updateHelp', '%urlextensions%');
    this.loadExtensions();
  }
};

function extensionsData() {
    return {
        list: [],
    }
}
</script>
