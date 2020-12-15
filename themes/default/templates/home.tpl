<script type="text/x-template" id="home">
  <v-container style="height:100%;padding-top: 32px">
    <v-tabs v-model="tab">
        <v-tab>%list%</v-tab>
        <v-tab>%recently%</v-tab>
        <v-tab>%favorites%</v-tab>
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
        <v-breadcrumbs :items="breads" large v-show="!search" class="pt-0 pl-2 pb-1">
          <template v-slot:item="{ item }">
          <v-breadcrumbs-item href="#" @click="return folder('/' + item.path)":disabled="item.disabled">
            {{item.text}}
          </v-breadcrumbs-item>
          </template>
        </v-breadcrumbs>
        <cardlist :list="curlist" v-on:folder="folder($event)"></cardlist>
    </div>
    <div style="height:calc(100% - 48px);" v-show="tab==1" class="pt-4">
        <cardlist :list="runlist"></cardlist>
    </div>
    <div style="height:calc(100% - 48px);" v-show="tab==2" class="pt-4">
    <v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" @click="addfolder = !addfolder">
            <v-icon left small>fa-folder-plus</v-icon>&nbsp;%newfolder%
        </v-btn>
    </v-toolbar>
    <div style="display: flex;" class="ml-2" v-show="addfolder">
        <v-text-field class="mx-2" style="max-width: 300px" v-model="foldername" label="%foldername%"
        ></v-text-field>
        <v-btn @click="newFolder" class="mt-2 mr-2" color="primary">%ok%</v-btn>
        <v-btn @click="addfolder=false" class="mt-2">%cancel%</v-btn>
    </div>
    <li v-for ="(item,index) in favs">
        {{item.name}}, {{item.isfolder}}
    </li>
  </v-container>
</script>

<script>
const Home = {
  template: '#home',
  data: homeData,
  methods: {
    newFolder() {
      this.addfolder = false
      store.commit('updateFavs', {name: this.foldername, isfolder: true, action: 'new'});
      this.$root.saveFavs()
      this.foldername = ''
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
        this.curlist = this.$root.filterList(this.search, this.path);
    },
    folder(name) {
      let ret = getBreads(name, this.path)
      this.path = ret.path
      this.breads = ret.breads
      this.viewlist()
      return false
    }
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
    favs: function() { return store.state.favs },
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
        path: '',
        addfolder: false,
        foldername: '',
        curlist: null,
        runlist: null,
        breads: getBreads('','').breads,
    }
}
</script>
