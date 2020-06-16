<script type="text/x-template" id="editor">
  <v-container style="height:100%;">
    <v-toolbar dense flat=true>
      <v-icon v-if="script.embedded" left small>fa-lock</v-icon><v-toolbar-title>{{script.settings.title}}</v-toolbar-title>
      <v-spacer></v-spacer>
        <v-menu left>
            <template v-slot:activator="{ on: history }">
               <v-tooltip bottom>
                <template v-slot:activator="{ on: tooltip }">
                    <v-btn
                        icon
                        color="primary"
                        v-on="{ ...tooltip, ...history }"
                        :disabled="!script.history"
                    >
                        <v-icon>fa-history</v-icon>
                    </v-btn>
                </template>
                <span>%history%</span>
                </v-tooltip>
            </template>
            <v-list dense>
              <v-list-item
                v-for="(item, i) in script.history"
                :key="i"
                @click="load(item.name)"
              >
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        <v-btn color="primary" class="mx-2" @click="load('new')" >
            <v-icon left small>fa-plus</v-icon>&nbsp;%newscript%
        </v-btn>
        <v-btn color="primary" class="mx-2" :disabled="!changed || script.embedded" @click="this.$root.saveScript">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
        <v-btn color="primary" class="mx-2" @click="saveas"
             v-if="!!script.original && script.original != script.settings.name">
            <v-icon left small>fa-save</v-icon>&nbsp;%saveasnew%
        </v-btn>
        <v-btn color="primary" class="mx-2"  v-if="loaded && !script.settings.unrun" 
            :disabled="!script.original"
             @click="$root.run(script.original)">
            <v-icon left small>fa-play</v-icon>&nbsp;%run%
        </v-btn>
          <v-menu bottom left v-if="loaded" offset-y v-if="!!script.original">
            <template v-slot:activator="{ on }">
               <v-btn color="primary" class="mx-2" v-on="on">
               <v-icon left small>fa-caret-down</v-icon>&nbsp;%menu%
               </v-btn>
            </template>
            <v-list dense>
              <v-list-item
                v-for="(item, i) in scriptmenu()"
                :key="i"
                @click=item.onclick
              >
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        <v-spacer></v-spacer>
    </v-toolbar>

    <v-tabs v-model="tab"  v-if="loaded">
        <v-tab>%script%</v-tab>
        <v-tab>%settings%</v-tab>
        <v-tab>%parameters%</v-tab>
        <v-tab>%sourcecode%</v-tab>
    </v-tabs>

    <!--v-tabs-items v-model="tab"  v-if="loaded"-->
    <div v-show="loaded && tab==0" style="height: calc(100% - 106px);overflow-y:auto;display:flex;" 
          class="py-4 pr-5 flex-wrap flex-sm-nowrap">  
        <tree :obj="script.tree" class="flex-grow-0 flex-shrink-1"></tree>
        <card></card>
    </div>
    <div v-show="loaded && tab==1"  style="height: calc(100% - 106px);overflow-y:auto;">  
          <v-text-field v-model="script.settings.name" @input="change"
           label="%name%" counter maxlength="32" hint="a-z, 0-9, .-_"
            :rules="[rules.required, rules.unique]"></v-text-field>
          <v-text-field v-model="script.settings.title" @input="change"
          label="%title%" counter maxlength="64" :rules="[rules.required]"
        ></v-text-field>
        <v-textarea  v-model="script.settings.desc" @input="change"
         label="%desc%" rows="2" dense
         ></v-textarea>
        <v-select label="%loglevel%" @change="change"
                          v-model="script.settings.loglevel"
                          :items="LogLevel" 
                          ></v-select>
        <v-checkbox v-model="script.settings.unrun"  @change="change"
            label="%unrun%"
        ></v-checkbox>
    </div>
    <div v-show="loaded && tab==2"  style="height: calc(100% - 106px);overflow-y:auto;">  
        <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headParams"
          :items="script.params"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgParams" max-width="600px">
                <template v-slot:activator="{ on }">
                  <v-btn color="primary" dark class="mb-2" v-on="on">%newitem%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgParamTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="editedItem.name"
                      label="%name%" counter maxlength="32" hint="a-z, 0-9, .-_"
                      :rules="[rules.required, rules.name]"></v-text-field>
                      <v-text-field v-model="editedItem.title"
                      label="%title%" counter maxlength="64" :rules="[rules.required]"
                      ></v-text-field>
                      <v-select label="%type%"
                          v-model="editedItem.type"
                          :items="PTypes" 
                          ></v-select>
                      <v-textarea  v-model="editedItem.options"
                      label="%additional%" auto-grow dense
                      ></v-textarea>
                    </v-container>
                  </v-card-text>

                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveParams">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeParams">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{ item.name }}</td>
                  <td>{{item.title}}</td>
                  <td>{{ PTypes[item.type].text }}</td>
                  <td>{{item.options}}</td>
                  <td><span @click="editParams(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="moveParams(index, -1)" class="mr-2" v-show="index>0">
                      <v-icon small @click="">fa-angle-double-up</v-icon></span>
                      <span @click="moveParams(index, 1)" class="mr-2" v-show="index<items.length-1">
                      <v-icon small @click="">fa-angle-double-down</v-icon></span>
                      <span @click="deleteParams(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
          <!--template v-slot:no-data>
            <v-btn color="primary" click="initialize">%newitem%</v-btn>
          </template-->
        </v-data-table>
      </div>
      <div v-show="loaded && tab==3" class="pt-3" style="height: calc(100% - 106px);overflow-y:auto;">  
         <v-textarea  v-model="script.code" @input="change"
         label="%sourcecode%" auto-grow dense
         ></v-textarea>
      </div>
  </v-container>
</script>

<script>
const Langs = [
   [[range $key, $native := .Langs ]]{text: '[[$native]]', value: '[[$key]]'},[[end]]
];

const LogLevel = [
    {text: '%disable%', value: 0},
    {text: '%error%', value: 1},
    {text: '%warning%', value: 2},
    {text: '%info%', value: 3},
    {text: '%debug%', value: 4},
    {text: '%inherit%', value: 5},
];

const PCheckbox = 0;
const PTextarea = 1;
const PSingleText = 2;
const PSelect = 3;
const PNumber = 4;
const PTypes = [
    {text: '%checkbox%', value: 0, comp: 'c-checkbox'},
    {text: '%textarea%', value: 1, comp: 'c-textarea'},
    {text: '%singletext%', value: 2, comp: 'c-singletext'},
    {text: '%select%', value: 3, comp: 'c-select'},
    {text: '%number%', value: 4, comp: 'c-number'},
    {text: '%list%', value: 5, comp: 'c-list'},
];//.sort((a,b) => (a.text > b.text) ? 1 : ((b.text > a.text) ? -1 : 0));

const patScript = /^[a-z][a-z\d\._-]*$/
const patName = /^[a-z][a-z\d\_]*$/

const Editor = Vue.component('editor', {
    template: '#editor',
    data: editorData,
    mixins: [changed],
    methods: {
        runsilently() {
          this.$root.run(this.script.original, true)
        },
        delete() {
          let comp = this;
          this.$root.confirmYes( '%delscript%', 
            function(){
                axios
                .post('/api/delete?name=' + comp.script.original)
                .then(response => {
                    if (response.data.error) {
                        comp.$root.errmsg(response.data.error);
                        return
                    }
                    comp.load('');
                })
                .catch(error => this.$root.errmsg(error));
           }); 
        },
        updateScript(response) {
                if (!!response.data.history) {
                    response.data.history = response.data.history.filter( 
                           (i) => i.name != response.data.settings.name );
                }
                if (!response.data.params) 
                    response.data.params = [];
                if (!response.data.tree) {
                  response.data.tree = [];
                } 
                this.script = response.data;
                ilist = store.state.list[this.script.settings.name]
                if (ilist)
                   this.script.embedded = ilist.embedded
                addsysinfo(this.script.tree, null)
                if (this.script.tree && this.script.tree.length > 0) {
                  this.active = this.script.tree[0];
                } else {
                  this.active = null;
                }
        },
        open() {
            this.loaded = false;
            axios
            .get('/api/script' + ( !!this.toopen ? '?name='+this.toopen : ''))
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updateScript(response)
                this.loaded = true;
            })
            .catch(error => this.$root.errmsg(error));
        },
        load(scriptname) {
            this.toopen = scriptname;
            this.$root.checkChanged(this.open);
        },
        saveas() {
            this.script.original = '';
            this.script.embedded = false;
            this.$root.saveScript();
        },
        closeParams () {
            this.dlgParams = false
            this.editedIndex = -1
            this.editedItem = {type: 0}
        },
        deleteParams (index) {
            let comp = this;
            this.$root.confirmYes( '%delconfirm%', 
            function(){
                comp.script.params.splice(index, 1)
                comp.change()
           });               
        },
        editParams (index) {
            this.editedIndex = index
            this.editedItem = Object.assign({}, this.script.params[index])
            if (!!this.editedItem.options) {
              this.editedItem.options = JSON.stringify(this.editedItem.options)
            }
//            this.editedItem = JSON.stringify(item);
            this.dlgParams = true
        },
        moveParams (index, direct) {
            const tmp = this.script.params[index+direct];
            this.$set(this.script.params, index+direct, this.script.params[index]);
            this.$set(this.script.params, index, tmp);
            this.change()
        },
        saveParams () {
            if (!this.editedItem.name || !patName.test(this.editedItem.name)) {
                this.$root.errmsg(format("%invalidfield%", '%name%'))
                return
            }
            if (!this.editedItem.title) {
                this.$root.errmsg(format("%invalidfield%", '%title%'))
                return
            }
            if (!this.editedItem.options) {
              this.editedItem.options = '{}'
            }
            this.editedItem.options = JSON.parse(this.editedItem.options);
            if (this.editedIndex > -1) {
                this.$set(this.script.params, this.editedIndex, Object.assign({}, this.editedItem))
            } else {
                this.script.params.push(this.editedItem);
            }
            this.change()
            this.closeParams()
        },
        scriptmenu() {
          return this.menu.filter( (i) => !i.ifcond || i.ifcond() );
        },
        canrun() {
           return this.loaded && !this.script.settings.unrun
        },
        noembed() {
           return !this.script.embedded
        },
        exportScript() {
          window.location = '/api/export?name=' + this.script.original
        },
        importScript() {
          let comp = this

          this.$root.uploadDlg('%importtitle%', function(par){
            const formData = new FormData();
            if (!par.files.length) return;
            Array
            .from(Array(par.files.length).keys())
            .map(x => {
               formData.append('files', par.files[x], par.files[x].name);
            });
            formData.set('overwrite', par.overwrite);
            axios({
              method: 'post',
              url: '/api/import',
              data: formData,
              headers: {'Content-Type': 'multipart/form-data' }
            })
            .then( response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.$root.checkChanged(function(){
                  comp.updateScript(response)
                })
            })
            .catch( error => comp.$root.errmsg(error));
          })
        },
    },
    mounted: function() {
        store.commit('updateTitle', '%editor%');
        let par = '';
        if (this.$route.query.scriptname) {
            par = this.$route.query.scriptname
        }
        if (!this.loaded || !!par) {
            this.load(par);
        }
    },
    computed: {
        script: {
            get() { return store.state.script },
            set(value) { store.commit('updateScript', value) }
        },
/*        changed: {
            get() { return store.state.changed },
            set(value) { store.commit('updateChanged', value) }
        },*/
        loaded: {
            get() { return store.state.loaded },
            set(value) { store.commit('updateLoaded', value) }
        },
        dlgParamTitle () {
            return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
        },
    },
    watch: {
      dlgParams (val) {
        val || this.closeParams()
      },
    },
});

function editorData() {
    return {
        tab: null,
        develop: [[.Develop]],
        toopen: '',
        menu: [
            { title: '%import%', onclick: this.importScript },
            { title: '%export%', onclick: this.exportScript },
            { title: '%runsilently%', onclick: this.runsilently, ifcond: this.canrun },
            { title: '%delete%', onclick: this.delete, ifcond: this.noembed  },
        ],
        rules: {
          required: value => !!value || '%required%',
          unique: value => {
            return patScript.test(value) || '%invalidvalue%'
          },
          name: value => {
            return patName.test(value) || '%invalidvalue%'
          },
        },
        dlgParams: false,
        editedIndex: -1,
        editedItem: {type: 0},
        headParams: [{
            text: '%name%',
            value: 'name',
            },{
            text: '%title%',
            value: 'title',
            },{
            text: '%type%',
            value: 'type',
            },{
            text: '%additional%',
            value: 'options',
            },{
            text: '%actions%',
            value: 'actions',
            },
        ],
    }
}

function addsysinfo(data, parent) {
  if (!data) {
    return
  }
   for (let i = 0; i<data.length; i++) {
     data[i].__parent = parent;
     if (!data[i].values) {
       data[i].values = {};
     }
     if (data[i].children && data[i].children.length > 0) {
         addsysinfo(data[i].children, data[i]);
     }
   }
}

</script>