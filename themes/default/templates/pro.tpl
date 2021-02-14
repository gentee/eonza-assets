<script type="text/x-template" id="pro">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>%general%</v-tab>
        <v-tab>%users%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <v-alert type="success" v-show="active" text outlined>%status%: %active%</v-alert>
        <v-alert type="error" v-show="!active" text outlined color="deep-orange">%status%: %disable%</v-alert>
        <div style="background-color: #FFFDE7;padding: 1rem; border-radius:8px; color: #455A64; 
            border: 1px solid #37474F;">
            <h3>%trialmode%</h3>
            <p v-if="trial.mode >=0"><b>{{trialday}}</b></p>
            <p v-else><b>%trialend%</b></p>
            <v-btn stylex="text-transform:none" @click="mode(1)" v-if="trial.mode == 0" color="primary">%starttrial%</v-btn>
            <v-btn stylex="text-transform:none" @click="mode(0)" v-if="trial.mode == 1" color="primary">%stoptrial%</v-btn>
        </div>
        <v-btn color="green" class="my-5 white--text">%upgradepro%</v-btn>
    </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;" >
        <div class="pt-4">
          <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headRoles"
          :items="roles"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgRoles" max-width="600px">
                <template v-slot:activator="{ on }">
                  <strong>Roles</strong><v-btn color="primary" :disabled="!active" dark class="ml-4" v-on="on">%newitem%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgRoleTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eRoleItem.name" 
                      label="%name%" :rules="[rules.required]"></v-text-field>
                     <v-btn color="primary" dark class="my-2" @click="addCommand">
                      <v-icon left small>fa-plus</v-icon>&nbsp;%allow%</v-btn>
                      <v-textarea  v-model="eRoleItem.allow" :rules="[rules.required]"
                      label="Allow" auto-grow dense
                      ></v-textarea>
                      <div style="display:flex">
                      <v-select class="mr-2" label="%tasks%: %view%" v-model="eRoleItem.tasks" :items="masks" 
                        item-text="title"
                        item-value="value"
                      ></v-select>
                      <v-select class="ml-2" label="%tasks%: %delete%" v-model="eRoleItem.tasksdel" :items="masks" 
                        item-text="title"
                        item-value="value"
                      ></v-select>
                      </div>
                      <div style="display:flex">
                      <v-select class="mr-2" label="%notifications%: %view%" v-model="eRoleItem.notifications" :items="masks" 
                        item-text="title"
                        item-value="value"
                      ></v-select>
                      <v-select class="ml-2" label="%notifications%: %delete%" v-model="eRoleItem.notificationsdel" :items="masks" 
                        item-text="title"
                        item-value="value"
                      ></v-select>
                      </div>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveRole">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeRole">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{item.name }}</td>
                  <td>{{item.allow}}</td>
                  <td>{{itasks(item)}}</td>
                  <td>{{inotifications(item)}}</td>
                  <td><div v-show="active"><span @click="editRole(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteRole(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                      </div>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
        </div>
    </div>

  </v-container>
</script>

<script>

const Masks = {
    0: '---',
    1: 'USER',
    3: 'GROUP',
    7: 'ALL',
}

function roleMasks(list) {
    for (let i=0; i < list.length; i++) {
        let item = list[i]
        item.tasksdel = item.tasks >> 8
        item.tasks = item.tasks & 0xff
        item.notificationsdel = item.notifications >> 8
        item.notifications = item.notifications & 0xff
        list[i] = item
    }
    console.log('list', list)
    return list.filter((item)=> item.id != 1)
}

const Pro = {
    template: '#pro',
    data() {
        return {
            tab: 0,
            active: false,
            trial: {},
            rules: {
                required: value => !!value || '%required%',
                var: value => { return patVar.test(value) || '%invalidvalue%' },
            },
            dlgRoles: false,
            editedIndex: -1,            
            eRoleItem: {id: 0, tasks: 1, tasksdel: 0, notifications: 1, notificationsdel: 0, allow: ''},
            roles: [],
            masks: [
                {title: '---', value: 0},
                {title: 'ALL', value: 7},
                {title: 'GROUP', value: 3},
                {title: 'USER', value: 1},
            ],
            headRoles: [{
                text: '%name%',
                value: 'name',
                },{
                text: '%allow%',
                value: 'allow',
                },{
                text: '%tasks%',
                value: 'tasks',
                },{
                text: '%notifications%',
                value: 'notifications',
                },{
                text: '%actions%',
                value: 'actions',
                },
            ],

        }
    },
    methods: {
        mode(par) {
            axios
            .get(`/api/trial/`+par)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.trial = response.data.trial
                this.active = response.data.active
            })
            .catch(error => this.$root.errmsg(error))
        },
        saveRole() {
            this.eRoleItem.tasks = this.eRoleItem.tasks | (this.eRoleItem.tasksdel<<8)
            this.eRoleItem.notifications = this.eRoleItem.notifications | (this.eRoleItem.notificationsdel<<8)
            axios
            .post(`/api/role`, this.eRoleItem)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.roles = roleMasks(response.data.list)
                this.closeRole()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeRole() {
            this.dlgRoles = false
            this.editedIndex = -1
            this.eRoleItem = {id: 0, tasks: 1, tasksdel: 0, notifications: 1, notificationsdel: 0, allow: ''}
        },
        editRole(index) {
            this.editedIndex = index
            this.eRoleItem = Object.assign({}, this.roles[index])
            this.dlgRoles = true
        },
        deleteRole(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removerole/` + comp.roles[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.roles = roleMasks(response.data.list)
            })
            .catch(error => comp.$root.errmsg(error));
           });   
        },
        /*change() {
            if (!this.changed) {
                this.changed = true;
            }
        },*/
        save() {
/*            this.$root.checkChanged(() => axios
            .post(`/api/settings`, this.options)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                location.reload(true)
                this.changed = false
            })
            .catch(error => this.$root.errmsg(error)));*/
        },
        addCommand() {
            let comp = this;
            this.$root.newCommand(function(par) {
                if (!!par) {
                    if (!!comp.eRoleItem.allow ) {
                        comp.eRoleItem.allow += ', ' + par    
                    } else {
                        comp.eRoleItem.allow = par    
                    }
                }
            })
        },
        itasks(item) {
            return Masks[item.tasks] + '/' + Masks[item.tasksdel]
        },
        inotifications(item) {
            return Masks[item.notifications] + '/' + Masks[item.notificationsdel]
        },
    },
    computed: {
        trialday() {
           return format('%trialdays%', this.trial.count, 30)
       },
        dlgRoleTitle () {
            return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
        },
    },
    mounted: function() {
        store.commit('updateTitle', '%prover%');
//        store.commit('updateHelp', '%urlpro%');
        axios
        .get(`/api/prosettings`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.active = response.data.active
            this.trial = response.data.trial
        })
        .catch(error => this.$root.errmsg(error));
        axios
        .get(`/api/roles`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.roles = roleMasks(response.data.list)
        })
        .catch(error => this.$root.errmsg(error));
    },
};

</script>