<script type="text/x-template" id="pro">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <!--v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar-->
    <v-tabs v-model="tab">
        <v-tab>%general%</v-tab>
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
  </v-container>
</script>

<script>

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
    },
    computed: {
       trialday() {
           return format('%trialdays%', this.trial.count, 30)
       }
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
    },
};

</script>