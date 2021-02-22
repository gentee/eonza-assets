<script type="text/x-template" id="favcard">
     <div>
      <v-tooltip top>
          <template v-slot:activator="{ on: nomenu }">
          <v-btn class="ma-2" style="top:-8px; right:-8px;position:absolute" :color="color" small icon 
              @click="fav('')" v-on="{...nomenu}" v-show="!isfavmenu">
              <v-icon small>fa-star</v-icon>
          </v-btn> 
          </template>
          <span>{{hint}}</span>
      </v-tooltip>
     <v-menu bottom left
        offset-y
        :close-on-content-click="!selfolder"
      >
      <template v-slot:activator="{ on: menu }">
          <v-tooltip top>
          <template v-slot:activator="{ on: tooltip }">
          <v-btn class="ma-2" style="top:-8px; right:-8px;position:absolute" :color="color" small icon 
              v-on="{ ...tooltip, ...menu }" v-show="isfavmenu" @click="selfolder=true">
              <v-icon small>fa-star</v-icon>
          </v-btn> 
          </template>
          <span>{{hint}}</span>
          </v-tooltip>
    </template>
    <v-card class="pa-2">
      <v-card-text class="pb-0"><v-select outlined :items = "folders" label="%foldername%" v-model="curfolder" dense></v-select></v-card-text>
      <v-card-actions>
       <v-btn class="mr-2" style="float:left;min-width:70px" small color="primary" @click="fav(curfolder)">%ok%</v-btn>
       <v-btn small stylex="float:right" @click="selfolder = false">%cancel%</v-btn>
      </v-card-actions>
    </v-card>
   </v-menu>
   </div>
</script>

<script type="text/x-template" id="cardlist">
    <div class="d-flex flex-wrap" 
       style="max-height:calc(100% - 106px);overflow-y: auto;">
    <!--div-->
         <v-card
          v-for="(item, i) in list"
          :key="i" style="max-width: 350px;" :color="item.group ? '#FFF9C4' : 'white'"
          class="ma-2 d-flex flex-column justify-space-between"
        >
          <favcard :name="item.name" :folders="folders" v-if="!item.group"></favcard>
          <v-card-title v-text="item.title"></v-card-title>
          <v-card-subtitle v-text="desc(item)"></v-card-subtitle>
          <div class="d-flex justify-space-around mb-2 align-end" v-if="!item.group">
          <v-btn class="ma-2" color="primary" small v-if="!item.unrun" @click="$root.run(item.name)">
           <v-icon left small>fa-play</v-icon> %run%
          </v-btn>
          [[if eq .User.RoleID 1]]<v-tooltip top>
            <template v-slot:activator="{ on }">
                          <v-btn @click="edit(item.name)" icon color="primary" v-on="on"  >
                              <v-icon>fa-edit</v-icon>
                          </v-btn>
            </template>
            <span>%edit%</span>
          </v-tooltip>[[end]]
          <v-tooltip top v-if="!item.unrun">
            <template v-slot:activator="{ on }">
                          <v-btn @click="$root.run(item.name, true)" icon color="primary" v-on="on"  >
                              <v-icon>fa-angle-right</v-icon>
                          </v-btn>
            </template>
            <span>%runsilently%</span>
          </v-tooltip>
          </div>
          <div class="d-flex justify-center mb-2 align-end" v-if="item.group">
            <v-btn class="ma-2" color="primary" small @click="folder(item.title)">
            <v-icon left small>fa-folder-open</v-icon> %open%
            </v-btn>
          </div>
        </v-card>
    </div>
</script>

<script>
Vue.component('favcard', {
    template: '#favcard',
    data: function(){
      return {
        selfolder: false,
        curfolder: '',
      }
    },
    computed: {
        color() { return !!store.state.isfav[this.name] ? 'yellow darken-1' : 'grey lighten-2' },
        hint() { return !!store.state.isfav[this.name] ? '%removefav%' : '%addfav%' },
        isfavmenu() { return !store.state.isfav[this.name] && this.folders.length>0 },
    },
    methods: {
        hide(event) {
          this.selfolder = false
        },
        fav(foldername) {
          this.selfolder = false
          store.commit('updateFavs', {name: this.name, isfolder: false, folder: foldername, 
                                      action: !!store.state.isfav[this.name] ? 'delete' : 'new'});
          this.$root.saveFavs()
          setTimeout(this.$root.favButtons, 1000)
        },
    },
    props: ['name', 'folders'],
});

Vue.component('cardlist', {
    template: '#cardlist',
    computed: {
        folders() {
          let ret = []
          for (let i=0; i < store.state.favs.length; i++) {
            if (store.state.favs[i].isfolder) {
              ret.push(store.state.favs[i].name)
            }
          }
          return ret
        },
    },
    methods: {
        folder(name) {
            this.$emit('folder', name);
        },
        edit(name) {
        this.$router.push('/editor?scriptname=' + name);
        },
    },
    props: {
        list: Array,
    },
});
</script>