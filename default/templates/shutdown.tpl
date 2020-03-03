<script type="text/x-template" id="shutdown">
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
    <v-alert max-width="400px;" class="pa-5"
      color="grey darken-4"
      dark
      icon="fa-power-off"
      prominent
    >
      <h1>[[lang "exitalert"]]</h1>
    </v-alert>
    </v-layout>
  </v-container>
</script>

<script>
const Shutdown = {
  template: '#shutdown'
};
</script>
