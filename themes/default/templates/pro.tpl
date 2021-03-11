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
        <v-tab>%security%</v-tab>
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
                  <strong>%roles%</strong><v-btn color="primary" :disabled="!active" dark class="ml-4" v-on="on">%new%</v-btn>
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
                      label="%allow%" auto-grow dense
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
        <div class="pt-4">
          <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headUsers"
          :items="users"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgUsers" max-width="600px">
                <template v-slot:activator="{ on }">
                  <strong>%users%</strong><v-btn color="primary" :disabled="!active" dark class="ml-4" v-on="on">%new%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgRoleTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eUserItem.nickname" 
                      label="%name%" :rules="[rules.required]"></v-text-field>
                      <v-text-field
                       v-model="eUserItem.password" name="password"
                       :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'"
                       :type="show1 ? 'text' : 'password'" label="%password%" hint="" 
                         @click:append="show1 = !show1"
                          ></v-text-field>
                      <v-select class="mr-2" label="%role%" v-model="eUserItem.roleid" 
                          :items="[{name: 'admin', id: 1}, ...roles]" 
                        item-text="name"
                        item-value="id"
                      ></v-select>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveUser">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeUser">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{item.nickname }}</td>
                  <td>{{irole(item)}}</td>
                  <td><div v-show="active"><span @click="editUser(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteUser(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                      </div>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
        </div>
    </div>
    <div v-show="tab==2" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <v-checkbox
        v-model="settings.twofa"
        :disabled="!active" @change="changesettings"
        label="%twofa%"
        ></v-checkbox>
        <v-btn @click="logoutall" color="primary" style="text-transform:none;">%logoutall%</v-btn>
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

const ProTabHelp = [
  '%urlpro-general%',
  '%urlpro-users%',
  '%urlpro-security%',
];

function roleMasks(list) {
    for (let i=0; i < list.length; i++) {
        let item = list[i]
        item.tasksdel = item.tasks >> 8
        item.tasks = item.tasks & 0xff
        item.notificationsdel = item.notifications >> 8
        item.notifications = item.notifications & 0xff
        list[i] = item
    }
    return list.filter((item)=> item.id != 1)
}

const Pro = {
    template: '#pro',
    data() {
        return {
            tab: 0,
            active: false,
            settings: {twofa: false},
            show1: false,
            trial: {},
            rules: {
                required: value => !!value || '%required%',
                var: value => { return patVar.test(value) || '%invalidvalue%' },
            },
            dlgRoles: false,
            dlgUsers: false,
            editedIndex: -1,            
            eRoleItem: {id: 0, tasks: 1, tasksdel: 0, notifications: 1, notificationsdel: 0, allow: ''},
            eUserItem: {id: 0, nickname: '', roleid: 1},
            roles: [],
            users: [],
            masks: [
                {title: '---', value: 0},
                {title: 'ALL', value: 7},
                {title: 'GROUP', value: 3},
                {title: 'USER', value: 1},
            ],
             headUsers: [{
                text: '%name%',
                value: 'nickname',
                },{
                text: '%role%',
                value: 'roleid',
                },{
                text: '%actions%',
                value: 'actions',
                },
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
        logoutall() {
            axios
            .get(`/api/logoutall`)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                location.reload()
            })
            .catch(error => this.$root.errmsg(error));
        },
        changesettings() {
            axios
            .post(`/api/proset`, this.settings)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.settings = response.data.settings
            })
            .catch(error => this.$root.errmsg(error));
        },
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
        saveUser() {
            let user = Object.assign({}, this.eUserItem)
            user.nickname += '/@/' + (user.password || '')
            axios
            .post(`/api/user`, user)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.users = response.data.list.filter((item)=> item.id != 1)
                this.closeUser()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeUser() {
            this.dlgUsers = false
            this.editedIndex = -1
            this.eUserItem = {id: 0, nickname: '', roleid: 1}
        },
        editUser(index) {
            this.editedIndex = index
            this.eUserItem = Object.assign({}, this.users[index])
            this.dlgUsers = true
        },
        deleteUser(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removeuser/` + comp.users[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.users = response.data.list.filter((item)=> item.id != 1)
            })
            .catch(error => comp.$root.errmsg(error));
           });   
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
        irole(item) {
            if (item.roleid == 1) {
                return 'admin'
            }
            for (let i = 0; i < this.roles.length; i++) {
                if (this.roles[i].id == item.roleid) {
                    return this.roles[i].name
                }
            }
            return ''
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
        store.commit('updateHelp', ProTabHelp[this.tab]);
        axios
        .get(`/api/prosettings`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.active = response.data.active
            this.trial = response.data.trial
            this.settings = response.data.settings
        })
        .catch(error => this.$root.errmsg(error));
        axios.get(`/api/roles`).then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.roles = roleMasks(response.data.list)
        }).catch(error => this.$root.errmsg(error));
        axios.get(`/api/users`).then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.users = response.data.list.filter((item)=> item.id != 1)
        }).catch(error => this.$root.errmsg(error));
    },
    watch: {
      tab(val) {
        store.commit('updateHelp', ProTabHelp[val]);
      }, 
    },
};

</script>