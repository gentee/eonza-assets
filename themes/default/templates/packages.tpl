<script type="text/x-template" id="packages">
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
        <v-btn color="primary" @click="editSettings(item)" v-show="item.installed"
        ><v-icon small>fa-cog</v-icon>&nbsp;%settings%</v-btn>
        <v-btn @click="uninstall(item.name)" v-show="item.installed"
        ><v-icon color="primary" small>fa-trash-alt</v-icon>&nbsp;%uninstall%</v-btn>
        <v-btn color="primary" @click="install(item.name)" v-show="!item.installed"><v-icon small >fa-download</v-icon>&nbsp;%install%</v-btn>
    </div>
  </div>
      </v-card>
    </div>
    <v-dialog v-model="dlgPackage" max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">%settings% - {{dlgTitle}}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <component v-for="comp in settings.params"
            :is="PTypes[comp.type].comp" v-bind="{par:comp,vals:settings.values}"></component>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn class="ma-2" color="primary" href="https://www.eonza.org%urlpro-general%" target="_help">%help%</v-btn>
          <v-spacer></v-spacer>
          <v-btn class="ma-2" color="primary" xclick="savePackage">%save%</v-btn>
          <v-btn class="ma-2" color="primary" text outlined  @click="closePackage">%cancel%</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</script>

<script>
const Packages = {
  template: '#packages',
  data: packagesData,
  methods: {
    loadPackages() {
        axios
        .get('/api/packages')
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.list = response.data.list
        })
        .catch(error => this.$root.errmsg(error));
      },
      install(name) {
        axios
        .get('/api/pkginstall/' + name)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.list = response.data.list
        })
        .catch(error => this.$root.errmsg(error));
      },
      uninstall(name) {
        let comp = this;
        this.$root.confirmYes( '%unpkgconfirm%', 
        function(){
          axios
            .get('/api/pkguninstall/' + name)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.list = response.data.list
            })
            .catch(error => comp.$root.errmsg(error));
        }); 
      },
      editSettings(item) {
        axios
        .get('/api/package/'+item.name)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.dlgTitle = item.title
            this.settings = response.data
            this.dlgPackage = true
            console.log('settings', this.settings)
        })
        .catch(error => this.$root.errmsg(error));
      },
      closePackage() {
            this.dlgPackage = false
        },
  },
  mounted() {
    store.commit('updateTitle', '%packages%');
    store.commit('updateHelp', '%urlpackages%');
    this.loadPackages();
  }
};

function packagesData() {
    return {
      dlgPackage: false,
      list: [],
      dlgTitle: '',
      settings: {
        params: [{
          name: "test",
          title: "OOOPS",
          options: {},
          type: 2
        }],
        values: {
          test: "this is a value"
        },
      }
    }
}
</script>
