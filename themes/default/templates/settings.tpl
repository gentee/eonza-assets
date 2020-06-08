<script type="text/x-template" id="settings">
  <v-container style="max-width: 1024px;height:100%;">
    <v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;[[lang "save"]]
        </v-btn>
    </v-toolbar>
    <v-tabs v-model="tab">
        <v-tab>[[lang "common"]]</v-tab>
        <v-tab>[[lang "personal"]]</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
   <div class="pt-4">
   <v-select label="[[lang "loglevel"]]" @change="change"
                          v-model="options.common.loglevel"
                          :items="list" 
                          ></v-select>
    </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;"> 
    <div class="pt-4">
        <v-select label="[[lang "language"]]" @change="change"
            v-model="options.user.lang"
            :items="Langs" 
        ></v-select>
        </div>
    </div>

  </v-container>
</script>

<script>

const Settings = {
    template: '#settings',
    data() {
        return {
            tab: 0,
            options: {
                common: {
                    loglevel: 3,
                },
                user: {
                    lang: 'en',
                }
            },
            changed: false,
        }
    },
    methods: {
        change() {
            if (!this.changed) {
                this.changed = true;
            }
        },
        save() {
            axios
            .post(`/api/settings`, this.options)
            .then(response => {
                if (response.data.error) {
                    this.errmsg(response.data.error);
                    return
                }
                this.changed = false
            })
            .catch(error => this.errmsg(error));
        }
    },
    computed: {
        list() {return LogLevel.filter( (i) => i.value < 5 )}
    },
    mounted: function() {
        store.commit('updateTitle', [[lang "settings"]]);
        axios
        .get(`/api/settings`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.options = response.data
        })
        .catch(error => this.$root.errmsg(error));
    },

};

</script>