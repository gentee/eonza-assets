<script type="text/x-template" id="settings">
  <v-container style="max-width: 1024px;height:100%;">
    <v-toolbar dense flat=true>
        <v-btn color="primary" class="mx-2" :disabled="!changed" xclick=".saveScript">
            <v-icon left small>fa-save</v-icon>&nbsp;[[lang "save"]]
        </v-btn>
    </v-toolbar>
   <div class="pt-3">
   <v-select label="[[lang "loglevel"]]" changex="change"
                          vxmodel="script.settings.loglevel"
                          :items="list" 
                          ></v-select>
    </div>
  </v-container>
</script>

<script>

const Settings = {
    template: '#settings',
    data() {
        return {
            changed: false,
        }
    },
    computed: {
        list() {return LogLevel.filter( (i) => i.value < 5 )}
    },
    mounted: function() {
        store.commit('updateTitle', [[lang "settings"]]);
    },

};

</script>