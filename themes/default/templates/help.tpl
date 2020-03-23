<script type="text/x-template" id="help">
  <v-container style="max-width: 1024px;height:100%;">
    <v-tabs v-model="tab">
        <v-tab>[[lang "about"]]</v-tab>
        <v-tab>[[lang "licagreement"]]</v-tab>
    </v-tabs>

    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;" >
          <h2 class="my-4">[[.App.Title]]</h2>
          <h3>Freeware</h3>
          <p>[[lang "version"]]: <b>[[.Version]]</b>
          </p>
          <p>Copyright [[.App.Copyright]]
          </p>
          <h3>[[lang "support"]]</h3>
          <a href="mailto:[[.App.Email]]">[[.App.Email]]</a>
      </div>
      <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;"> 
         <div class="pt-4">
         [[html .App.License]]
         </div>
      </div>
    </div>

  </v-container>
</script>

<script>

const Help = {
    template: '#help',
    data: helpData,
    mounted: function() {
        store.commit('updateTitle', [[lang "help"]]);
    },

};

function helpData() {
    return {
      tab: null
    }
}

</script>