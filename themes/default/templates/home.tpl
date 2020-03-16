<script type="text/x-template" id="home">
  <v-container fluid>
    <v-tabs v-model="tab">
        <v-tab>[[lang "list"]]</v-tab>
        <v-tab>[[lang "recently"]]</v-tab>
    </v-tabs>

     <v-tabs-items v-model="tab">
      <v-tab-item>  
        <div class="d-flex pt-5">
        <v-text-field class="mx-2" append-icon="fa-search" v-model="search" 
          label="[[lang "search"]]"
          outlined @input="tosearch"
        ></v-text-field>
        <v-btn @click="clearsearch" class="mt-3" icon color="primary" v-if="!!search">
          <v-icon>fa-times</v-icon>
        </v-btn>
        </div>
        <v-layout class="d-flex flex-wrap">
         <v-card class="ma-2"
          v-for="(item, i) in curlist"
          :key="i"
        >
          <v-card-title v-text="item.title"></v-card-title>
          <v-card-subtitle v-text="item.name"></v-card-subtitle>
          <div class="d-flex justify-space-around">
          <v-btn class="ma-2" color="primary" small>
           <v-icon left>fa-play</v-icon> [[lang "run"]]
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
        </v-layout>
      </v-tab-item>
      <v-tab-item >
         2
        </v-tab-item>
    </v-tabs-items>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
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
    errmsg( title ) {
      this.errtitle = title;
      this.error = true;
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
        let ret = [];
        for (let key in this.list) {
          let val = this.list[key];
          if (!val.title) continue;
          if (!!this.search && !val.title.toLowerCase().includes(this.search.toLowerCase())) continue;
          ret.push(val);
        }
        this.curlist = ret;
     }
  },
  mounted: function() {
    store.commit('updateTitle', [[lang "scripts"]]);
    axios
    .get('/api/list')
    .then(response => {
        if (response.data.error) {
            this.errmsg(response.data.error);
            return
        }
        this.list = response.data.list;
        this.viewlist();
    })
    .catch(error => this.errmsg(error));
  },
};

function homeData() {
    return {
        tab: null,
        list: null,
        search: '',
        error: false,
        errtitle: '',
        curlist: null,
    }
}
</script>
