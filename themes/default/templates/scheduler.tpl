<script type="text/x-template" id="scheduler">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>%timers%</v-tab>
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
                  <v-btn color="primary" dark class="ml-4" v-on="on">%new%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgTimerTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-text-field v-model="eTimerItem.name" label="%name%"></v-text-field>
                      <div style="display:flex">
                         <v-text-field v-model="eTimerItem.script" :rules="[rules.required]" label="%script%"></v-text-field>
                          <v-btn color="primary" dark class="my-2 ml-2" @click="selectScript">
                      %select%</v-btn>
                      </div>
                      <table style="width: 100%">
                        <tr><td style="width: 70%">
                          <v-text-field class="mr-2 mb-3" dense label="Minute" placeholder="0-5,10,45" outlined hide-details></v-text-field>
                        </td><td><v-text-field class="ml-2 mb-3" dense  label="Every [?] minute(s)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                            <v-text-field  class="mr-2 mb-3" dense label="Hour" placeholder="0,9-17,23" outlined hide-details></v-text-field>
                        </td><td>
                            <v-text-field  class="ml-2 mb-3" dense label="Every [?] hour(s)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                          <v-text-field  class="mr-2 mb-3" dense label="Day" placeholder="3-10,12,25" outlined hide-details></v-text-field>
                        </td><td>
                           <v-text-field  class="ml-2 mb-3" dense label="Every [?] day(s)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                           <v-select  class="mr-2 mb-3"
                              vxx-model="value" dense
                              :items="CronMonths"
                              item-text="title"
                              item-value="value" hide-details
                              chips
                              label="Month"
                              multiple 
                              outlined
                            ></v-select>
                        </td><td>
                           <v-text-field  class="ml-2 mb-3" dense label="Every [?] month(s)" outlined hide-details></v-text-field>
                        </td></tr>
                        <tr><td>
                           <v-select  class="mr-2 mb-3"
                              vxx-model="value" dense
                              :items="CronWeekday"
                              item-text="title"
                              item-value="value" hide-details
                              chips
                              label="Weekday"
                              multiple 
                              outlined
                            ></v-select>
                        </td><td>
                           <v-text-field  class="ml-2 mb-3" dense label="Every [?] week(s)" outlined hide-details></v-text-field>
                        </td></tr>
                      </table>
                      <v-checkbox v-model="eTimerItem.disable" label="%disable%"></v-checkbox>
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
  </v-container>
</script>

<script>

let CronMonths = []

let CronWeekday = []

function cronInit() {
  let months = '%monthshort%'.split(',')
  for (let i = 0; i < months.length; i++) {
     CronMonths.push({title: months[i], value: i+1 })
  }
  let weekday = '%weekshort%'.split(',')
  for (let i = 0; i < weekday.length; i++) {
     CronWeekday.push({title: weekday[i], value: i })
  }
}

cronInit();

const SchedulerTabHelp = [
  '%urlsch-timers%',
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
            editedIndex: -1,            
            eTimerItem: {id: 0, script: '', cron: '* * * * *'},
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
        }
    },
    methods: {
      stattimer(item) {
        return (item.next.length > 0 ? item.next : `%disable%`)
      },
      selectScript() {
            let comp = this;
            this.$root.newCommand(function(par) {
                if (!!par) {
                    comp.eTimerItem.script = par    
                }
            })
      },
      saveTimer() {
            let timer = Object.assign({}, this.eTimerItem)
            timer.active = !timer.disable
            console.log('Save', timer)
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
        editTimer(index) {
            this.editedIndex = index
            this.eTimerItem = Object.assign({}, this.timers[index])
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
    },
    computed: {
        dlgTimerTitle () {
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
    },
    watch: {
      tab(val) {
        store.commit('updateHelp', SchedulerTabHelp[val]);
      }, 
    },
};

</script>