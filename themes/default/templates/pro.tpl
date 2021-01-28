<script type="text/x-template" id="pro">
  <v-container style="max-width: 1024px;height:100%;padding-top: 40px;">
    <v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="save">
            <v-icon left small>fa-save</v-icon>&nbsp;%save%
        </v-btn>
    </v-toolbar>
    <v-tabs v-model="tab">
        <v-tab>%general%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
   <div class="pt-4">
        Pro Test
    </div>
  </v-container>
</script>

<script>

const Pro = {
    template: '#pro',
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
        change() {
            if (!this.changed) {
                this.changed = true;
            }
        },
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
    mounted: function() {
        store.commit('updateTitle', '%prover%');
//        store.commit('updateHelp', '%urlpro%');
/*        axios
        .get(`/api/settings`)
        .then(response => {
            if (response.data.error) {
                this.$root.errmsg(response.data.error);
                return
            }
            this.options = response.data
            this.loadConst()
        })
        .catch(error => this.$root.errmsg(error));*/
    },
};

</script>