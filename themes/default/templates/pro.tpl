<script type="text/x-template" id="pro">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>%users%</v-tab>
        <v-tab>%settings%</v-tab>
        <v-tab>%storage%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
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
                    <v-btn class="ma-2" color="primary" href="https://www.eonza.org%urlpro-users%" target="_help">%help%</v-btn>
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
                    <v-btn class="ma-2" color="primary" href="https://www.eonza.org%urlpro-users%" target="_help">%help%</v-btn>
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
                  <td><div v-show="active"><span v-if="item.id != 1" @click="editUser(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span v-if="item.id != 1" @click="deleteUser(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                      <span v-if="[[.Twofa]]" @click="qrcodeUser(index)" class="mr-2">
                      <v-icon small @click="">fa-qrcode</v-icon></span>
                      </div>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
        </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <v-checkbox
        v-model="settings.autofill"
        :disabled="!active" @change="changesettings"
        label="%autofill%"
        ></v-checkbox>
        <div style="color: #777;"><strong>%security%</strong></div>
        <v-checkbox
        v-model="settings.twofa"
        :disabled="!active" @change="changesettings"
        label="%twofa%"
        ></v-checkbox>
        <v-btn @click="logoutall" :disabled="!active" color="primary">%logoutall%</v-btn>
    </div>
    </div>
    <div v-show="tab==2" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <div v-if="!storageis"> 
            <v-text-field v-model="master" label="%masterpass%" :disabled="!active"
            :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'" :type="show1 ? 'text' : 'password'"
            style="width: 250px;" @click:append="show1 = !show1"
            :rules="[rules.required]"></v-text-field>
            <v-text-field v-model="confmaster" label="%confpass%" :disabled="!active"
            :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'" :type="show1 ? 'text' : 'password'"
                style="width: 250px;" @click:append="show1 = !show1"
            :rules="[rules.required]"></v-text-field>
            <v-btn @click="createstorage" color="primary" :disabled="!active">%createstorage%</v-btn>
        </div>
        <div v-else>
            <div v-if="storageenc"> 
                <v-text-field v-model="master" label="%masterpass%" :disabled="!active"
                :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'" :type="show1 ? 'text' : 'password'"
                style="width: 250px;" @click:append="show1 = !show1"
                :rules="[rules.required]"></v-text-field>
                <v-btn @click="decryptstorage" color="primary" :disabled="!active">%decrypt%</v-btn>
            </div>
            <div v-else> 
               <v-btn @click="encryptstorage" color="primary">%disable%</v-btn>
                <v-dialog v-model="dlgStoragePass" max-width="600px">
                    <template v-slot:activator="{ on }">
                       <v-btn color="primary" dark class="ml-4" v-on="on">%changepass%</v-btn>
                    </template>
                    <v-card>
                    <v-card-title>
                        <span class="headline">%changepass%</span>
                    </v-card-title>
                    <v-card-text>
                        <v-container>
                        <v-text-field v-model="chpass.current" label="%curpassword%" :rules="[rules.required]" 
                        :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'" :type="show1 ? 'text' : 'password'"
                        @click:append="show1 = !show1"
                        ></v-text-field>
                        <v-text-field v-model="chpass.master" label="%masterpass%" :rules="[rules.required]" 
                        :append-icon="show2 ? 'fa-eye' : 'fa-eye-slash'" :type="show2 ? 'text' : 'password'"
                        @click:append="show2 = !show2"
                        ></v-text-field>
                        <v-text-field v-model="chpass.confmaster" label="%confpass%" :rules="[rules.required]" 
                        :append-icon="show3 ? 'fa-eye' : 'fa-eye-slash'" :type="show3 ? 'text' : 'password'"
                        @click:append="show3 = !show3"
                        ></v-text-field>
                        </v-container>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn class="ma-2" color="primary" @click="changePassword">%changepass%</v-btn>
                        <v-btn class="ma-2" color="primary" text outlined  @click="closeChangePassword">%cancel%</v-btn>
                    </v-card-actions>
                    </v-card>
                </v-dialog>

                <v-data-table class="mt-8"
                disable-filtering disable-pagination disable-sort hide-default-footer
                :headers="headStorage"
                :items="storagelist"
                >
                <template v-slot:top>
                    <v-dialog v-model="dlgStorage" max-width="600px">
                        <template v-slot:activator="{ on }">
                        <strong>%secstorage%</strong><v-btn color="primary" dark class="ml-4" v-on="on">%new%</v-btn>
                        </template>
                        <v-card>
                        <v-card-title>
                            <span class="headline">{{ dlgRoleTitle }}</span>
                        </v-card-title>

                        <v-card-text>
                            <v-container>
                            <v-text-field v-model="eStorageItem.name" 
                            label="%name%" :rules="[rules.required]"></v-text-field>
                            <v-text-field v-model="eStorageItem.desc" 
                            label="%desc%"></v-text-field>
                            <v-text-field v-model="eStorageItem.value" 
                            :label="eStorageItem.id ? '%newvalue%' : '%value%'"></v-text-field>
                            </v-container>
                        </v-card-text>
                        <v-card-actions>
                            <v-btn class="ma-2" color="primary" href="https://www.eonza.org%urlpro-storage%" target="_help">%help%</v-btn>
                            <v-spacer></v-spacer>
                            <v-btn class="ma-2" color="primary" @click="saveStorage">%save%</v-btn>
                            <v-btn class="ma-2" color="primary" text outlined  @click="closeStorage">%cancel%</v-btn>
                        </v-card-actions>
                        </v-card>
                    </v-dialog>
                </template>
                <template v-slot:body="{ items }">
                    <tbody>
                        <tr v-for="(item, index) in items" :key="item.name">
                        <td>{{item.name }}</td>
                        <td>{{item.desc}}</td>
                        <td><div v-show="active"><span @click="editStorage(index)" class="mr-2">
                            <v-icon small @click="">fa-pencil-alt</v-icon>
                            </span>
                            <span @click="deleteStorage(index)" class="mr-2">
                            <v-icon small @click="">fa-times</v-icon></span>
                            </div>
                        </td>
                        </tr>
                    </tbody>
                    </template>
                </v-data-table>

            </div>
        </div>
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
  '%urlpro-users%',
  '%urlpro-security%',
  '%urlpro-storage%',
];

const NOTACTIVATED = 6;

const LicStatus = [
    {title: `None`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
	{title: `%invalid%`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
	{title: `%blocked%`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
	{title: `%expired%`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
	{title: `%difdrive%`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
    {title: `%exceeded%`, color: `red`, txtcolor: `white`, icon: `fa-exclamation-circle`},
    {title: `%notactivated%`, color: `yellow`, txtcolor: `grey darken-3`, icon: `fa-exclamation-circle`},
    {title: `%active%`, color: `green`, txtcolor: `white`, icon: `fa-check-circle`},
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
            site: [[.App.Homepage]],
            tab: 0,
            license: {status: 0, license: ''},
            active: false,
            settings: {twofa: false, master: ''},
            show1: false,
            show2: false,
            show3: false,
            master: '',
            confmaster: '',
            storagelist: [],
            storageis: [[.AskMaster]],
            storageenc: true,
            chpass: {current: '', master: '', confmaster: ''},
            trial: {},
            rules: {
                required: value => !!value || '%required%',
                var: value => { return patVar.test(value) || '%invalidvalue%' },
            },
            dlgRoles: false,
            dlgKey: false,
            licenseKey: '',
            dlgUsers: false,
            dlgStorage: false,
            dlgStoragePass: false,
            editedIndex: -1,            
            eRoleItem: {id: 0, tasks: 1, tasksdel: 0, notifications: 1, notificationsdel: 0, allow: ''},
            eUserItem: {id: 0, nickname: '', roleid: 1},
            eStorageItem: {id: 0, name: '', value: '', desc: ''},
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
            headStorage: [{
                text: '%name%',
                value: 'name',
                },{
                text: '%desc%',
                value: 'desc',
                },{
                text: '%actions%',
                value: 'actions',
                },
            ],
        }
    },
    methods: {
        updatestorage(data) {
            if (data) {
                this.storageis = data.created
                this.storageenc = data.encrypted
                this.storagelist = data.list 
                this.$root.askmaster = this.active && this.storageenc && this.storageis
            }
            console.log(data, this.active, this.$root.askmaster)
        },
        changePassword() {
            axios
            .post(`/api/storagepassword`, this.chpass)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updatestorage(response.data)
                this.closeChangePassword()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeChangePassword() {
            this.dlgStoragePass = false
            this.chpass = {current: '', master: '', confmaster: ''}
        },
        saveStorage() {
            axios
            .post(`/api/storage`, this.eStorageItem)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updatestorage(response.data)
                this.closeStorage()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeStorage() {
            this.dlgStorage = false
            this.editedIndex = -1
            this.eStorageItem = {id: 0, name: '', desc: '', value: ''}
        },
        editStorage(index) {
            this.editedIndex = index
            this.eStorageItem = Object.assign({}, this.storagelist[index])
            this.dlgStorage = true
        },
        deleteStorage(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removestorage/` + comp.storagelist[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.updatestorage(response.data)
            })
            .catch(error => comp.$root.errmsg(error));
           });   
        },
        decryptstorage() {
            this.$root.decryptstorage(this.master, this.updatestorage)
        },
        encryptstorage() {
            axios
            .post(`/api/encryptstorage`)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updatestorage(response.data)
            })
            .catch(error => this.$root.errmsg(error));
        },
        createstorage() {
           if (!this.master) {
               this.$root.errmsg(format("%errreq%", '%masterpass%'))
               return
           }
           if (this.master != this.confmaster) {
               this.$root.errmsg('%masterpass% != %confpass%')
               return
           }
            axios
            .post(`/api/createstorage`, {master: this.master, confmaster: this.confmaster})
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updatestorage(response.data)
                this.master = ''
                this.confmaster = ''
            })
            .catch(error => this.$root.errmsg(error));
        },
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
                this.updatestorage(response.data.storage)
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
                this.users = response.data.list//.filter((item)=> item.id != 1)
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
                comp.users = response.data.list//.filter((item)=> item.id != 1)
            })
            .catch(error => comp.$root.errmsg(error));
           });   
        },
        qrcodeUser(index) {
            let comp = this
            this.$root.confirmYes( '%reset2fa%', 
            function(){
            axios
            .get(`/api/reset2fa/` + comp.users[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
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
        dlgRoleTitle () {
            return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
        },
    },
    mounted: function() {
        if (this.site[this.site.length-1] == '/') {
            this.site = this.site.substr(0, this.site.length-1)
        }
        store.commit('updateTitle', '%advanced%');
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
            this.license = response.data.license
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
            this.users = response.data.list//.filter((item)=> item.id != 1)
        }).catch(error => this.$root.errmsg(error));
    },
    watch: {
      tab(val) {
        store.commit('updateHelp', ProTabHelp[val]);
        if (val == 2) {
            axios.get(`/api/storage`).then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.updatestorage(response.data)
            }).catch(error => this.$root.errmsg(error));
        }
      }, 
    },
};

</script>