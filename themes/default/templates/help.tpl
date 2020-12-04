<script type="text/x-template" id="help">
  <v-container style="max-width: 1024px;height:100%;">
    <v-tabs v-model="tab">
        <v-tab>%about%</v-tab>
    </v-tabs>

    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
          <h2 class="my-4">[[.App.Title]]</h2>
          <h3>%annotation%</h3>
          <p>%version%: <b>[[.Version]]</b> <small style="color: #777;">[[.CompileDate]]</small>
          </p>
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
    mounted: function() {
        store.commit('updateTitle', '%help%');
        store.commit('updateHelp', '%urlhelp%');
    },

};

function helpData() {
    return {
      tab: null
    }
}

</script>