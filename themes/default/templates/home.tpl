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
    <div style="max-height:calc(100% - 76px);overflow-y: auto;" class="mt-3">
      <v-data-table disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="heads"
          :items="favlist"
        >
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td :class="item.pad" >
                   <v-tooltip top>
          <template v-slot:activator="{ on }">
             <v-btn icon small class="mr-2" v-on="on" @click="favclick(item)"><v-icon small 
                 :color="item.isfolder ? 'primary' : 
                 'yellow darken-1'">{{item.icon}}</v-icon></v-btn>
          </template><span>{{item.hint}}</span></v-tooltip>{{ item.title }}</td>
                  <td><span v-if="!item.isfolder" @click="jumpto(item.name)" class="mr-2">
                      <v-icon small @click="">fa-external-link-alt</v-icon>
                      </span>
                      <span @click="delFavGroup(item.name)" class="mr-2" v-if="item.empty">
                      <v-icon small @click="">fa-trash-alt</v-icon></span>
                      <span @click="moveFav(index, false)" class="mr-2" v-show="index>0">
                      <v-icon small @click="">fa-angle-double-up</v-icon></span>
                      <span @click="moveFav(index, true)" class="mr-2" v-show="index<items.length-1">
                      <v-icon small @click="">fa-angle-double-down</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
      </div>
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
      setTimeout(this.$root.favButtons, 1000)
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
    },
    getFavList() { 
      let ret = []
      for (let i = 0; i < store.state.favs.length; i++) {
        let item = store.state.favs[i]
        let title = item.name
        if (store.state.list && store.state.list[title]) {
          title = store.state.list[title].title
        }
        let hint = '%removefav%'
        let icon = 'fa-star'
        let isgroup = false
        let empty = false
        if (item.isfolder) {
          if (this.openedfav[item.name]) {
            icon = 'fa-folder-open'
            hint = '%collapse%'
            isgroup = true
          } else {
            icon = 'fa-folder'
            hint = '%expand%'
          }
          empty = !item.children || item.children.length == 0
        }
        ret.push({ isfolder: item.isfolder, name: item.name, title: title, icon: icon, 
            hint: hint, pad: '', empty: empty})
        if (isgroup && item.children) {
            for (let j = 0; j < item.children.length; j++) {
              let sub = item.children[j]
              let title = sub.name
              if (store.state.list && store.state.list[title]) {
                title = store.state.list[title].title
              }
              ret.push({ isfolder: false, name: sub.name, title: title, icon: 'fa-star', 
                 hint: '%removefav%', pad: 'pl-10', folder: item.name})
            }
        }
      }
      this.curfavlist = ret
    },
    favclick(item) {
      if (!item.isfolder) {
         store.commit('updateFavs', {name: item.name, action: 'delete' });
          this.$root.saveFavs()
          setTimeout(this.$root.favButtons, 1000)
      } else {
        if (this.openedfav[item.name]) {
          delete this.openedfav[item.name]
        } else {
          this.openedfav[item.name] = true
        }
        this.getFavList()
      }
    },
    jumpto(name) {
      this.$router.push('/editor?scriptname=' + name);
    },
    delFavGroup(name) {
        store.commit('updateFavs', {name: name, action: 'delete', isfolder: true });
        this.$root.saveFavs()
        setTimeout(this.$root.favButtons, 1000)
    },
    moveFav(index, down) {
      let item = this.curfavlist[index];
      let next = index < this.curfavlist.length - 1 ? this.curfavlist[index+1] : null; 
      let prev = index > 0 ? this.curfavlist[index-1] : null; 
      let target = null
      let folder = ''
      let action = (down ? 'after' : 'before')
      if (down) {
        if (!next) {
          return
        }
        target = next.name
        if (!!item.folder) {
          if (next.folder) {
            folder = item.folder
          } else {
            action = 'before'
          }
        } else {
          if (next.isfolder && !item.isfolder) {
            if (this.openedfav[next.name]) {
               folder = next.name
               action = 'before'
               target = null
            }
          } 
        }
      } else {
        if (!prev) {
          return
        }
        target = prev.name
        if (!!item.folder) {
          if (prev.folder) {
            folder = prev.folder
          }
        } else {
          if (prev.folder && !item.isfolder) {
            folder = prev.folder
            action = 'after'
          } 
        }
      }
      store.commit('updateFavs', {name: item.name, folder: folder, target: target, 
             action: action, isfolder: false });
      this.$root.saveFavs()
      setTimeout(this.$root.favButtons, 1000)
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
    },
  },
  computed: {
    list: function() { return store.state.list },
    favlist: function() {this.getFavList()
      return this.curfavlist},
  },
  mounted: function() {
    store.commit('updateTitle', '%scripts%');
    store.commit('updateHelp', '%urlscripts%');
    this.$root.loadList(this.viewlist);
    this.getFavList()
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
        openedfav: {},
        curfavlist: [],
        runlist: null,
        heads: [
          'Scripts', 'Actions'
        ],
        breads: getBreads('','').breads,
    }
}
</script>
