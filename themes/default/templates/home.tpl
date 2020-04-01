<script type="text/x-template" id="home">
  <v-container style="height:100%;">
    <v-tabs v-model="tab">
        <v-tab>[[lang "list"]]</v-tab>
        <v-tab>[[lang "recently"]]</v-tab>
    </v-tabs>

    <div style="height:calc(100% - 48px);" v-show="tab==0">
        <div class="d-flex pt-5">
          <v-text-field class="mx-2" append-icon="fa-search" v-model="search" 
            label="[[lang "search"]]"
            outlined @input="tosearch"
          ></v-text-field>
          <v-btn @click="clearsearch" class="mt-3" icon color="primary" v-if="!!search">
            <v-icon>fa-times</v-icon>
          </v-btn>
        </div>
        <div class="d-flex flex-wrap" 
        style="max-height:calc(100% - 106px);overflow-y: auto;">
         <v-card
          v-for="(item, i) in curlist"
          :key="i" style="max-width: 350px;"
          class="ma-2 d-flex flex-column justify-space-between"
        > 
          <v-card-title v-text="item.title"></v-card-title>
          <v-card-subtitle v-text="desc(item)"></v-card-subtitle>
          <div class="d-flex justify-space-around mb-2 align-end">
          <v-btn class="ma-2" color="primary" small v-if="!item.unrun" @click="$root.run(item.name)">
           <v-icon left small>fa-play</v-icon> [[lang "run"]]
          </v-btn>
          <v-tooltip top>
            <template v-slot:activator="{ on }">
                          <v-btn @click="edit(item.name)" icon color="primary" v-on="on"  >
                              <v-icon>fa-edit</v-icon>
                          </v-btn>
            </template>
            <span>[[lang "edit"]]</span>
          </v-tooltip>
          </div>
          </v-card>
      </div>
    </div>
    <div style="height:calc(100% - 48px);" v-show="tab==1">
        Recently launched
    </div>
  </v-container>
</script>

<script>
const Home = {
  template: '#home',
  data: homeData,
  methods: {
    edit(name) {
      this.$router.push('/editor?scriptname=' + name);
    },
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
  computed: {
    list: function() { return store.state.list },
  },
  mounted: function() {
    store.commit('updateTitle', [[lang "scripts"]]);
    this.$root.loadList(this.viewlist);
  },
};

function homeData() {
    return {
        tab: null,
        search: '',
        curlist: null,
    }
}
</script>
