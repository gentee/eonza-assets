<script type="text/x-template" id="settings">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar>
    <v-tabs v-model="tab">
        <v-tab [[if ne .User.RoleID 1]]disabled[[end]]>%general%</v-tab>
        <v-tab [[if ne .User.RoleID 1]]disabled[[end]]>%scripts%</v-tab>
        <v-tab>%personal%</v-tab>
        <v-tab [[if ne .User.RoleID 1]]disabled[[end]]>%globconst%</v-tab>
        <v-tab>%security%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
   <div class="pt-4">
      <v-text-field v-model="options.common.title" label="%title%" @change="change"></v-text-field>
      [[if .Tray]]
      <v-checkbox v-model="options.common.hidetray" label="%hidetray%" @change="change"></v-checkbox>
      [[end]]
      <v-select label="%autocheck%" @change="change" style="max-width: 300px;"
        v-model="options.common.autoupdate" :items="period" 
        item-text="title"
        item-value="value"
        ></v-select>
      <div style="color: #777;"><strong>%taskmanager%</strong></div>
      <v-text-field v-model.number="options.common.removeafter" type="number"  style="max-width: 300px;"
      label="%removeafter%" @change="change"></v-text-field>
      <v-text-field v-model.number="options.common.maxtasks" type="number"  style="max-width: 300px;"
      label="%maxtasks%" @change="change"></v-text-field>
    </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;" >
   <div class="pt-4">
    <v-checkbox v-model="options.common.includesrc" label="%includesrc%" @change="change"></v-checkbox>
    <v-select label="%loglevel%" @change="change"
                          v-model="options.common.loglevel"
                          :items="list" 
                          ></v-select>
    </div>
    </div>
    <div v-show="tab==2" style="height: calc(100% - 106px);overflow-y:auto;"> 
    <div class="pt-4">
        <v-select label="%language%" @change="change"
            v-model="options.user.lang"
            :items="Langs" 
        ></v-select>
        </div>
    </div>
    <div v-show="tab==3" style="height: calc(100% - 106px);overflow-y:auto;"> 
        <div class="pt-4">
        <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headConst"
          :items="constants"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgConst" max-width="600px">
                <template v-slot:activator="{ on }">
                  <v-btn color="primary" dark class="mb-2" v-on="on">%newitem%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgConstTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eConstItem.name" 
                      label="%name%" counter maxlength="32" hint="a-z, 0-9, .-_"
                      :rules="[rules.required, rules.var]"></v-text-field>
                      <v-textarea  v-model="eConstItem.value" :rules="[rules.required]"
                      label="%value%" auto-grow dense
                      ></v-textarea>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveConst">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeConst">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{ item.name }}</td>
                  <td>{{item.value}}</td>
                  <td><span @click="editConst(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteConst(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
        </div>
    </div>
    <div v-show="tab==4" style="height: calc(100% - 106px);overflow-y:auto;" >
   <div class="pt-4">
    <!--v-checkbox v-model="options.common.includesrc" label="%includesrc%" @change="change"></v-checkbox-->
    [[if eq .User.ID 1]]
    <v-text-field type="password" label="%curpassword%" v-model="curpsw" v-if="!!options.common.passwordhash"></v-text-field>
    [[else]]
    <v-text-field type="password" label="%curpassword%" v-model="curpsw"></v-text-field>
    [[end]]
    <v-text-field type="password" label="%password%" v-model="psw"></v-text-field>
    <v-btn color="primary" :disabled="!psw && !curpsw" @click="setpsw">%setpassword%</v-btn>
    [[if eq .User.RoleID 1]]<v-checkbox  v-model="options.common.notaskpassword" label="%notaskpassword%"
        @change="change"></v-checkbox>[[end]]
    </div>
    </div>

  </v-container>
</script>

<script>

const Settings = {
    template: '#settings',
    data() {
        return {
            curpsw: '',
            psw: '',
            tab: [[if eq .User.RoleID 1]]0[[else]]2[[end]],
            period: [
                {title: '%never%', value: 'never'},
                {title: '%daily%', value: 'daily'},
                {title: '%weekly%', value: 'weekly'},
                {title: '%monthly%', value: 'monthly'},
            ],
            options: {
                common: {
                    loglevel: 3,
                    includesrc: false,
                    notaskpassword: false,
                    passwordhash: '',
                    constants: {},
                    autoupdate: '',
                },
                user: {
                    lang: 'en',
                }
            },
            changed: false,
            dlgConst: false,
            editedIndex: -1,            
            eConstItem: {},
            constants: [],
            headConst: [{
                text: '%name%',
                value: 'name',
                },{
                text: '%value%',
                value: 'value',
                },{
                text: '%actions%',
                value: 'actions',
                },
            ],
            rules: {
                required: value => !!value || '%required%',
                var: value => { return patVar.test(value) || '%invalidvalue%' },
            },
        }
    },
    methods: {
        change() {
            if (!this.changed) {
                this.changed = true;
            }
        },
        setpsw() {
            axios
            .post(`/api/setpsw`, {curpassword: this.curpsw, password: this.psw})
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                location.reload()
            })
            .catch(error => this.$root.errmsg(error));
        },
        save() {
//            this.options.common.removeafter = Number(this.options.common.removeafter)
            this.$root.checkChanged(() => axios
            .post(`/api/settings`, this.options)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                location.reload(true)
                this.changed = false
            })
            .catch(error => this.$root.errmsg(error)));
        },
        loadConst() {
          this.constants = []
          for (let key in this.options.common.constants) {
            this.constants.push( {name: key, value: this.options.common.constants[key] })
          }
          this.constants.sort(function(a, b){ return a.name.localeCompare(b.name) })
        },
        saveConst () {
            if (!this.eConstItem.name || !patVar.test(this.eConstItem.name)) {
                this.$root.errmsg(format("%invalidfield%", '%name%'))
                return
            }
            if (!this.eConstItem.value) {
                this.$root.errmsg(format("%invalidfield%", '%value%'))
                return
            }
            if (!this.options.common.constants) {
               this.options.common.constants = {}
            }
            if (this.editedIndex > -1) {
                let curName = this.constants[this.editedIndex].name
                if (curName != this.eConstItem.name ) {
                    delete this.options.common.constants[curName]
                }
                this.options.common.constants[this.eConstItem.name] = this.eConstItem.value
            } else {
                this.options.common.constants[this.eConstItem.name] = this.eConstItem.value
            }
            this.loadConst()
            this.change()
            this.closeConst()
        },
        deleteConst (index) {
            let comp = this;
            this.$root.confirmYes( '%delconfirm%', 
            function(){
                let name = comp.constants[index].name
                delete comp.options.common.constants[name]
                comp.loadConst()
                comp.change()
           });               
        },
        editConst (index) {
            this.editedIndex = index
            this.eConstItem = Object.assign({}, this.constants[index])
            this.dlgConst = true
        },
        closeConst () {
            this.dlgConst = false
            this.editedIndex = -1
            this.eConstItem = {}
        },
    },
    computed: {
        dlgConstTitle () {
            return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
        },
        list() {return LogLevel.filter( (i) => i.value < 6 )}
    },
    mounted: function() {
        store.commit('updateTitle', '%settings%');
        store.commit('updateHelp', '%urlsettings%');
        axios
        .get(`/api/settings`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.options = response.data
            this.loadConst()
        })
        .catch(error => this.$root.errmsg(error));
    },
    watch: {
        dlgConst (val) {
            val || this.closeConst()
      },
    }

};

</script>