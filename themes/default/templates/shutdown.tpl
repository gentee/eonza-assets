<script type="text/x-template" id="shutdown">
  <v-container fluid fill-height>
    <v-layout align-center justify-center style="display: flex;flex-direction: column;">
    <v-alert max-width="400px;" class="pa-5"
      color="grey darken-4"
      dark
      icon="fa-power-off"
      prominent
    >
      <h1>%exitalert%</h1>
    </v-alert>
     <v-btn color="primary" class="mx-2" @click="refresh" >
         <v-icon left small>fa-sync-alt</v-icon>&nbsp;%refresh%
     </v-btn>
     <v-alert v-show="failrun" class="mt-4" style="text-align:center;" color="yellow lighten-4">%failconnect%<br> <nowrap><strong>[[.AppPath]]</strong></nowrap>
     </v-alert>
    </v-layout>
  </v-container>
</script>

<script>
const Shutdown = {
  template: '#shutdown',
  data: function(){
    return {
        failrun: false
    }
  },
  methods: {
    refresh() {
        this.failrun = false
        let loc = window.location;
        axios
        .get('/ping')
        .then(response => {
            if (response.data.error || response.data != 'ok') {
                this.$root.errmsg(response.data.error);
                return
            }
            window.location = loc.origin
        })
        .catch(() => this.failrun = true);
    }
  }
};
</script>
