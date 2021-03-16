<script type="text/x-template" id="scheduler">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>Timers</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
    <div class="pt-4">
      Scheduler
    </div>
    </div>
  </v-container>
</script>

<script>

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
        }
    },
    methods: {
    },
    mounted: function() {
        store.commit('updateTitle', '%scheduler%');
        store.commit('updateHelp', SchedulerTabHelp[this.tab]);
    },
    watch: {
      tab(val) {
        store.commit('updateHelp', SchedulerTabHelp[val]);
      }, 
    },
};

</script>