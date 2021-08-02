<script type="text/x-template" id="browser">
  <v-container style="height:100%;padding-top: 40px;">
    <div style="height:calc(100% - 0px);overflow-y: auto;padding-top: 1rem">
         <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headers"
          :items="browsers"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgBrowser" max-width="700px">
                <template v-slot:activator="{ on }">
                  <v-btn color="primary" dark class="ml-4" v-on="on">%new%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgItemTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-textarea v-model="eBrowserItem.urls" label="URLs"></v-textarea>
                     <v-btn color="primary" dark class="my-2" @click="addCommand">
                      <v-icon left small>fa-plus</v-icon>&nbsp;%scripts%</v-btn>
                      <v-textarea  v-model="eBrowserItem.scripts" :rules="[rules.required]"
                      :key="scriptsKey"
                      label="%scripts%" auto-grow dense
                      ></v-textarea>
                      <v-checkbox
                      v-model="eBrowserItem.settings.html" label="%gethtml%"
                      ></v-checkbox>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                  <v-btn class="ma-2" color="primary" href="https://www.eonza.org%urlbrowser%" target="_help">%help%</v-btn>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveBrowser">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeBrowser">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{item.urls }}</td>
                  <td>{{item.scripts}}</td>
                  <td>{{item.settings}}</td>
                  <td><span @click="editBrowser(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteBrowser(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
    </div>
  </v-container>
</script>

<script>

const Browser = {
  template: '#browser',
  data: browserData,
  methods: {
    saveBrowser() {
        let browser = Object.assign({}, this.eBrowserItem)
        axios
        .post(`/api/savebrowser`, browser)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.browsers = response.data.list
            this.closeBrowser()
        })
        .catch(error => this.$root.errmsg(error));
    },
    closeBrowser() {
        this.dlgBrowser = false
        this.editedIndex = -1
        this.eBrowserItem = {id: 0, scripts: '', urls: '', settings: {html: false}}
    },
    addCommand() {
        let comp = this;
        this.$root.newCommand(function(par) {
            if (!!par) {
                if (!!comp.eBrowserItem.scripts ) {
                    comp.eBrowserItem.scripts += ', ' + par    
                } else {
                    comp.eBrowserItem.scripts = par    
                }
            }
            comp.scriptsKey++
        })
    },
        editBrowser(index) {
            this.editedIndex = index
            this.eBrowserItem = Object.assign({}, this.browsers[index])
            this.dlgBrowser = true
        },
        deleteBrowser(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removebrowser/` + comp.browsers[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.browsers = response.data.list
            })
            .catch(error => comp.$root.errmsg(error));
           });   
        },

  },
  computed: {
    dlgItemTitle () {
        return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
    },
  },
  mounted() {
    store.commit('updateTitle', '%browser%');
    store.commit('updateHelp', '%urlbrowser%');
     axios.get(`/api/browsers`).then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.browsers = response.data.list
        }).catch(error => this.$root.errmsg(error));     
  }
};

function browserData() {
    return {
        dlgBrowser: false,
        editedIndex: -1,            
        eBrowserItem: {id: 0, settings: {html: false}},
        scriptsKey: 0,
        browsers: [],
        rules: {
            required: value => !!value || '%required%',
        },
        headers: [{
            text: 'URLs',
            value: 'urls',
        },{
            text: '%scripts%',
            value: 'scripts',
        },{
            text: '%settings%',
            value: 'settings',
        },{
            text: '%actions%',
            value: 'actions',
            },
        ],
    }
}
</script>
