<script type="text/x-template" id="scheduler">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>%timers%</v-tab>
        <v-tab>%events%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headTimers"
          :items="timers"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgTimers" max-width="700px">
                <template v-slot:activator="{ on }">
                  <v-btn color="primary" @click="newCron" dark class="ml-4" v-on="on">%new%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgItemTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eTimerItem.name" label="%name%"></v-text-field>
                      <div style="display:flex">
                         <v-text-field v-model="eTimerItem.script" :rules="[rules.required]" label="%script%"></v-text-field>
                          <v-btn color="primary" dark class="my-2 ml-2" @click="selectScript">
                      %select%</v-btn>
                      </div>
                      <v-checkbox v-model="eTimerItem.disable" label="%disabled%"></v-checkbox>
                      <table style="width: 100%">
                        <tr><td style="width: 70%">
                          <v-text-field v-model="cd.m" class="mr-2 mb-3" dense label="%minute%" placeholder="0-5,10,45" outlined hide-details @change="changecd"></v-text-field>
                        </td><td><v-text-field v-model="cd.em"  @change="changecd" class="ml-2 mb-3" dense :label="every(0)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                            <v-text-field  v-model="cd.h" class="mr-2 mb-3"  @change="changecd" dense label="%hour%" placeholder="0,9-17,23" outlined hide-details></v-text-field>
                        </td><td>
                            <v-text-field  v-model="cd.eh" class="ml-2 mb-3"  @change="changecd" dense :label="every(1)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                          <v-text-field  v-model="cd.d" class="mr-2 mb-3"  @change="changecd" dense label="%day%" placeholder="3-10,12,25" outlined hide-details></v-text-field>
                        </td><td>
                           <v-text-field v-model="cd.ed" class="ml-2 mb-3"  @change="changecd" dense :label="every(2)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                           <v-select  class="mr-2 mb-3" @change="changecd"
                              v-model="cd.mo" dense
                              :items="CronMonths"
                              item-text="title"
                              item-value="value" hide-details
                              chips
                              label="%month%"
                              multiple 
                              outlined
                            ></v-select>
                        </td><td>
                           <v-text-field v-model="cd.emo" @change="changecd" class="ml-2 mb-3" dense :label="every(3)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                           <v-select  class="mr-2 mb-3"
                              v-model="cd.w" @change="changecd" dense
                              :items="CronWeekday"
                              item-text="title"
                              item-value="value" hide-details
                              chips
                              label="%weekday%"
                              multiple 
                              outlined
                            ></v-select>
                        </td><td>
                           <v-text-field v-model="cd.ew" @change="changecd" class="ml-2 mb-3" dense :label="every(4)" outlined hide-details></v-text-field>
                        </td></tr>
                      </table>
                      <div><strong>Cron: </strong>{{eTimerItem.cron}}</div>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveTimer">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeTimer">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{item.name }}</td>
                  <td>{{item.cron}}</td>
                  <td>{{stattimer(item)}}</td>
                  <td>{{item.script}}</td>
                  <td><span @click="editTimer(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteTimer(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
        </v-data-table>
    </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
        <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headEvents"
          :items="events"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgEvents" max-width="700px">
                <template v-slot:activator="{ on }">
                  <v-btn color="primary" dark class="ml-4" v-on="on">%new%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgItemTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eEventItem.name" label="%name%" :rules="[rules.required]"></v-text-field>
                      <div style="display:flex">
                         <v-text-field v-model="eEventItem.script" :rules="[rules.required]" label="%script%"></v-text-field>
                          <v-btn color="primary" dark class="my-2 ml-2" @click="selectScript">
                      %select%</v-btn>
                      </div>
                      <v-checkbox v-model="eEventItem.disable" label="%disabled%"></v-checkbox>
                      <v-text-field v-model="eEventItem.token" label="%token%"></v-text-field>
                      <v-textarea v-model="eEventItem.whitelist" label="%ipwhitelist%"></v-textarea>
                    </v-container>
                  </v-card-text-->
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveEvent">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeEvent">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">
                  <td>{{item.name }}</td>
                  <td>{{item.script}}</td>
                  <td>{{statevent(item)}}</td>
                  <td>{{item.token}}</td>
                  <td>{{item.whitelist}}</td>
                  <td><span @click="editEvent(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="deleteEvent(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
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

let CronMonths = []
let CronWeekday = []
let CronEvery = []

function cronInit() {
  let months = '%monthshort%'.split(',')
  for (let i = 0; i < months.length; i++) {
     CronMonths.push({title: months[i], value: i+1 })
  }
  let weekday = '%weekshort%'.split(',')
  for (let i = 0; i < weekday.length; i++) {
     CronWeekday.push({title: weekday[i], value: i })
  }
  let every = '%everytime%'.split(',')
  for (let i = 1; i < every.length; i++) {
     CronEvery.push(every[0] + ' [?] ' + every[i])
  }
}

cronInit();

const SchedulerTabHelp = [
  '%urlsch-timers%',
  '%urlsch-events%',
];

const Scheduler = {
    template: '#scheduler',
    data() {
        return {
            tab: 0,
            rules: {
                required: value => !!value || '%required%',
                var: value => { return patVar.test(value) || '%invalidvalue%' },
            },
            dlgTimers: false,
            dlgEvents: false,
            editedIndex: -1,            
            eTimerItem: {id: 0, script: '', cron: '* * * * *'},
            eEventItem: {id: 0, script: ''},
            cd: {},
            timers: [],
            headTimers: [{
                text: '%name%',
                value: 'name',
                },{
                text: 'Cron',
                value: 'cron',
                },{
                text: '%nextrun%',
                value: 'next',
                },{
                text: '%script%',
                value: 'script',
                },{
                text: '%actions%',
                value: 'actions',
                },
            ],
            events: [],
            headEvents: [{
                text: '%name%',
                value: 'name',
                },{
                text: '%script%',
                value: 'script',
                },{
                text: '%status%',
                value: 'active',
                },{
                text: '%token%',
                value: 'token',
                },{
                text: '%ipwhitelist%',
                value: 'whiteips',
                },{
                text: '%actions%',
                value: 'actions',
                },
            ],
        }
    },
    methods: {
      stattimer(item) {
        return (item.next.length > 0 ? item.next : `%disabled%`)
      },
      statevent(item) {
        return (item.active ? '%active%' : `%disabled%`)
      },
      selectScript() {
            let comp = this;
            this.$root.newCommand(function(par) {
                if (!!par) {
                    if (!comp.tab) {
                       comp.eTimerItem.script = par    
                    } else {
                       comp.eEventItem.script = par    
                    }
                }
            })
      },
      saveTimer() {
            let timer = Object.assign({}, this.eTimerItem)
            timer.active = !timer.disable
            axios
            .post(`/api/timer`, timer)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.timers = response.data.list
                this.closeTimer()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeTimer() {
            this.dlgTimers = false
            this.editedIndex = -1
            this.eTimerItem = {id: 0, script: '', cron: '* * * * *'}
        },
        parseCron() {
          let data = this.eTimerItem.cron.split(' ')
          let ids = ['m','h','d','mo','w']
          let ret = {}
          for (let i = 0; i < 5; i++) {
            if (!data[i]) {
              break
            }
            let id = ids[i]
            if (data[i] == '*') {
              ret[id] = ''
              ret['e'+id] = '1'
              continue
            }
            let li = data[i].split('/')
            if (i < 3) {
              ret[id] = li[0]
            } else {
              ret[id] = li[0].split(',')
              for (let j = 0; j < ret[id].length; j++) {
                ret[id][j] = Number(ret[id][j])
              }
            }
            if (li.length > 1) {
              ret['e'+id] = li[1]
            }
          }
          this.cd = ret
        },
        newCron() {
          this.eTimerItem = {id: 0, script: '', cron: '* * * * *'}
          this.parseCron()
        },
        editTimer(index) {
            this.editedIndex = index
            this.eTimerItem = Object.assign({}, this.timers[index])
            this.eTimerItem.disable = !this.eTimerItem.active
            this.parseCron()
            this.dlgTimers = true
        },
        deleteTimer(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removetimer/` + comp.timers[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.timers = response.data.list
            })
            .catch(error => comp.$root.errmsg(error));
           });   
        },
        changecd() {
          let ids = ['m','h','d','mo','w']
          let ret = []
          for (let i = 0; i < 5; i++) {
            let id = ids[i]
            let v = this.cd[id]
            let ev = this.cd['e' + id]
            if (i > 2) {
              v = (v.length>0 ? v.join(',') : '*')
            }
            if (!v) {
              v = '*'
            }
            if (!!ev && ev != '1') {
              v += '/' + ev
            }
            ret.push(v.replace(' ', ''))
          }
          this.eTimerItem.cron = ret.join(' ')
        },
        every(id) {
          return CronEvery[id]
        },
        saveEvent() {
            let event = Object.assign({}, this.eEventItem)
            event.active = !event.disable
            axios
            .post(`/api/saveevent`, event)
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.events = response.data.list
                this.closeEvent()
            })
            .catch(error => this.$root.errmsg(error));
        },
        closeEvent() {
            this.dlgEvents = false
            this.editedIndex = -1
            this.eEventItem = {id: 0, script: ''}
        },
        editEvent(index) {
            this.editedIndex = index
            this.eEventItem = Object.assign({}, this.events[index])
            this.eEventItem.disable = !this.eEventItem.active
            this.dlgEvents = true
        },
        deleteEvent(index) {
            let comp = this
            this.$root.confirmYes( '%delconfirm%', 
            function(){
            axios
            .get(`/api/removeevent/` + comp.events[index].id)
            .then(response => {
                if (response.data.error) {
                    comp.$root.errmsg(response.data.error);
                    return
                }
                comp.events = response.data.list
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
    mounted: function() {
        store.commit('updateTitle', '%scheduler%');
        store.commit('updateHelp', SchedulerTabHelp[this.tab]);
        axios.get(`/api/timers`).then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.timers = response.data.list
        }).catch(error => this.$root.errmsg(error));
        axios.get(`/api/events`).then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.events = response.data.list
        }).catch(error => this.$root.errmsg(error));        
    },
    watch: {
      tab(val) {
        store.commit('updateHelp', SchedulerTabHelp[val]);
      }, 
    },
};

</script>