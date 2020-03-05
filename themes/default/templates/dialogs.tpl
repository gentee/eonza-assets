<script type="text/x-template" id="dlg-question">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <v-card>
        <v-card-title classx="py-4">
          <v-icon size="2em" color="blue darken-2" class="mr-4 my-4">fa-question-circle
          </v-icon>{{title}}
        </v-card-title>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary"
            @click="click(btn.Yes)"  class="ma-2"
          >
            [[lang "yes"]]
          </v-btn>
          <v-btn
            color="primary" outlined
            @click="click(btn.No)"  class="ma-2"
          >
            [[lang "no"]]
          </v-btn>

        </v-card-actions>
      </v-card>
    </v-dialog>
</script>

<script>
const btn = {
    No: 0,
    Yes: 1,
}

Vue.component('dlg-question', {
    template: '#dlg-question',
    props: ['show', 'title'],
    methods: {
        click: function (par) {
            this.$emit('btn', par);
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
                case 13:
                case 32: 
                   this.click(btn.Yes);
                   break;
                case 27: 
                   this.click(btn.No);
                   break;
            }
        }
    },
    watch: {
        show(newval) {
            if (newval) {
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});

</script>

<script type="text/x-template" id="dlg-error">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <v-card>
        <v-card-title classx="py-4">
          <v-icon size="2em" color="error" class="mr-4 my-4">fa-times-circle
          </v-icon>{{title}}
        </v-card-title>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="orange darken-3" 
            @click="close()"  class="ma-2 white--text"
          >
            [[lang "ok"]]
          </v-btn>

        </v-card-actions>
      </v-card>
    </v-dialog>
</script>

<script>
Vue.component('dlg-error', {
    template: '#dlg-error',
    props: ['show', 'title'],
    methods: {
        close: function () {
            this.$emit('close');
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
                case 13:
                case 32: 
                case 27: 
                   this.close();
                   break;
            }
        }
    },
    watch: {
        show(newval) {
            if (newval) {
                window.addEventListener('keydown', this.keyProcess);
            } else {
                window.removeEventListener('keydown', this.keyProcess);
            }
        }
    }
});

</script>