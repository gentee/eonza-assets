<script type="text/x-template" id="help">
  <v-container style="max-width: 1024px;height:100%;padding-top: 32px">
    <v-tabs v-model="tab">
        <v-tab>%about%</v-tab>
    </v-tabs>

    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
          <h2 class="my-4">[[.App.Title]]</h2>
          <h3>%annotation%</h3>
          <p>%version%: <b>[[.Version]]</b> <small style="color: #777;">[[.CompileDate]]</small>
          <div v-if="upd.notify" v-html="upd.notify"></div>
          <div v-if="!upd.notify && upd.lastchecked">%uptodate%</div>
          <div v-if="upd.lastchecked">%lastcheck% <i>{{upd.lastchecked}}</i></div>
          <v-btn color="primary" style="text-transform:none;" @click="checkUpdate()"  class="ma-1">
            %checkupdate%
          </v-btn>
          </p>
          <p><strong><a href="%proverurl%" target="_blank">%prover%</a></strong></p>
          <p>Copyright [[.App.Copyright]]<br>
          
          <strong><a class="py-3" href="%licenseurl%" target="_blank">%licagreement%</a></strong>
</p>
          <h3 class="py-2">%officialsite%</h3>
          <p><strong><a href="[[.App.Homepage]]" target="_blank">[[.App.Homepage]]</a></strong></p>
          <h3 class="py-2">%support%</h3>
          <p><a href="mailto:[[.App.Email]]?Subject=Eonza">Email</a><br>
          <a href="[[.App.Issue]]" target="_blank">%repissue%</a><p>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;"> 
    </div>
  </v-container>
</script>

<script>

const Help = {
    template: '#help',
    data: helpData,
    methods: {
      checkUpdate() {
           axios
            .get('/api/latest')
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.upd = response.data
            })
            .catch(error => this.$root.errmsg(error));
      },
    },
    mounted: function() {
        store.commit('updateTitle', '%help%');
        store.commit('updateHelp', '%urlhelp%');
    },

};

function helpData() {
    return {
      upd: {
        version: [[.Update.Version]],
        notify:  [[.Update.Notify]],
        lastchecked: '[[time2str .Update.LastChecked]]',
      },
      tab: null
    }
}

</script>