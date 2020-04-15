<script type="text/x-template" id="dlg-question">
    <v-dialog v-model="show" max-width="600" persistent = true>
      <div>

      <v-card>
        <v-card-title classx="py-4">
        <div style="width: 100%;">
        <v-icon size="2em" color="blue darken-2" class="mr-4 my-4" style="float: left;">fa-question-circle
        </v-icon>
          <div>{{title}}</div>
        </div>
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

      </div>
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
        <div style="width: 100%;">
          <v-icon size="2em" color="error" class="mr-4 my-4" style="float: left;">fa-times-circle
          </v-icon><div>{{title}}</div>
        </div>
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

<script type="text/x-template" id="dlg-commands">
    <v-dialog v-model="show" max-width="700" persistent = true scrollable>
      <v-card>
        <v-card-title>[[lang "selcmd"]]</v-card-title>
        <v-divider></v-divider>
        <div class="d-flex pt-4 px-2">
          <v-text-field class="mx-2" append-icon="fa-search" v-model="search" 
            label="[[lang "search"]]"
            outlined @input="tosearch"
          ></v-text-field>
          <v-btn @click="clearsearch" class="mt-3" icon color="primary" v-if="!!search">
            <v-icon>fa-times</v-icon>
          </v-btn>
        </div>
        <v-card-text style="height: 400px;">
         <div  class="d-flex flex-wrap" style="margin-right: 2px;">
            <v-card style="border-left: 2px solid #f00;"
              v-for="(item, i) in curlist"
              :key="i" style="max-width: 350px;" @click="selectScript(item.name)"
              class="flex-grow-1 ma-2 pa-2 d-flex flex-column justify-space-between"
            > 
              <div style="font-weight: bold;"><v-icon color="primary">fa-check-square</v-icon>&nbsp;{{item.title}}
              </div>
              <div>{{desc(item)}}</div>
            </v-card>
          </div>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="primary" outlined
            @click="close('')"  class="ma-2"
          >
            [[lang "cancel"]]
          </v-btn>

        </v-card-actions>
      </v-card>
    </v-dialog>
</script>

<script>
Vue.component('dlg-commands', {
    template: '#dlg-commands',
    props: ['show'],
    data: dlgCommandsData,
    methods: {
        clearsearch() {
          this.search = '';
          //this.$forceUpdate();
          this.curlist;
        },
        tosearch() {
          if (this.search.length != 1) {
            this.curlist;
//          this.$forceUpdate();
          }
        },
        selectScript(name) {
          this.close(name)
        },
        close: function (par) {
            this.$emit('cmdname', par)
        },
        keyProcess: function(event) {
            switch (event.keyCode) {
//                case 13:
//                case 32: 
                case 27: 
                   this.close('');
                   break;
            }
        }
    },
    computed: {
      list: function() { return store.state.list },
      curlist: function() { return this.$root.filterList(this.search) },
    },
    mounted() {
      this.$root.loadList(this.viewlist);
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

function dlgCommandsData() {
    return {
        search: '',
    }
}

const stActive = 1
const stWaiting = 2
const stSuspended = 3
const stFinished = 4
const stTerminated = 5
const stFailed = 6
const stCrashed = 6

const statusList = [
    '', [[lang "active"]], [[lang "waiting"]], [[lang "suspended"]],
    [[lang "finished"]], [[lang "terminated"]], [[lang "failed"]], [[lang "crashed"]],
 ]
const statusColor = [
    '#fff', '#4CAF50', '#0277BD', '#EF6C00',
    '#fff', '#37474F', '#F44336', '#4E342E',
 ]
const statusIcon = [
    '', '', '', '',
    'fa-flag-checkered', 'fa-thumbs-down', 'fa-exclamation-triangle', 'fa-bug'
 ]

</script>