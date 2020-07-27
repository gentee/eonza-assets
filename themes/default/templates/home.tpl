<script type="text/x-template" id="home">
  <v-container style="height:100%;">
    <v-tabs v-model="tab">
        <v-tab>%list%</v-tab>
        <v-tab>%recently%</v-tab>
    </v-tabs>

    <div style="height:calc(100% - 48px);" v-show="tab==0">
        <div class="d-flex pt-5">
          <v-text-field class="mx-2" append-icon="fa-search" v-model="search" 
            label="%search%"
            outlined @input="tosearch"
          ></v-text-field>
          <v-btn @click="clearsearch" class="mt-3" icon color="primary" v-if="!!search">
            <v-icon>fa-times</v-icon>
          </v-btn>
        </div>
        <cardlist :list="curlist"></cardlist>
    </div>
    <div style="height:calc(100% - 48px);" v-show="tab==1" class="pt-4">
        <cardlist :list="runlist"></cardlist>
    </div>
  </v-container>
</script>

<script>
const Home = {
  template: '#home',
  data: homeData,
  methods: {
    clearsearch() {
      this.search = '';
      this.viewlist();
    },
    tosearch() {
      if (this.search.length != 1) {
        this.viewlist();
      } 
    },
    viewlist() {
        this.curlist = this.$root.filterList(this.search);
    },
  },
  watch: {
    tab(newValue) {
      if (newValue==1) {
        axios
        .get('/api/listrun')
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.runlist = response.data.list
        })
        .catch(error => this.$root.errmsg(error));
      }
    }
  },
  computed: {
    list: function() { return store.state.list },
  },
  mounted: function() {
    store.commit('updateTitle', '%scripts%');
    store.commit('updateHelp', '%urlscripts%');
    this.$root.loadList(this.viewlist);
  },
};

function homeData() {
    return {
        tab: null,
        search: '',
        curlist: null,
        runlist: null,
    }
}
</script>
