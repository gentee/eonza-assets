<script type="text/x-template" id="help">
  <v-container style="max-width: 1024px;">
    <v-tabs v-model="tab">
        <v-tab>[[lang "about"]]</v-tab>
        <v-tab>[[lang "licagreement"]]</v-tab>
    </v-tabs>

     <v-tabs-items v-model="tab">
       <v-tab-item>  
          <h2 class="my-4">[[.App.Title]]</h2>
          <h3>Freeware</h3>
          <p>[[lang "version"]]: <b>[[.Version]]</b>
          </p>
          <p>Copyright [[.App.Copyright]]
          </p>
          <h3>[[lang "support"]]</h3>
          <a href="mailto:[[.App.Email]]">[[.App.Email]]</a>
      </v-tab-item>
      <v-tab-item >
         <div class="pt-4">
         [[html .App.License]]
         </div>
      </v-tab-item>
    </v-tabs-items>

  </v-container>
</script>

<script>

const Help = {
    template: '#help',
    data: helpData,
};

function helpData() {
    return {
      tab: null
    }
}

</script>