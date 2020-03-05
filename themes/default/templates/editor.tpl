<script type="text/x-template" id="editor">
  <v-container fluid>
  <v-toolbar dense flat=true>
      <v-toolbar-title>{{script.settings.title}}</v-toolbar-title>
      <v-spacer></v-spacer>
        <v-btn color="primary" class="mx-2" @click="load('new')" >
            <v-icon left>fa-plus</v-icon>&nbsp;[[lang "newscript"]]
        </v-btn>
        <v-btn color="primary" class="mx-2" :disabled="!changed">
            <v-icon left>fa-save</v-icon>&nbsp;[[lang "save"]]
        </v-btn>
        <v-btn color="primary" class="mx-2"  v-if="loaded">
            <v-icon left>fa-play</v-icon>&nbsp;[[lang "run"]]
        </v-btn>
      <v-btn icon color="primary"  v-if="loaded">
        <v-icon>fa-caret-square-down</v-icon>
      </v-btn>
        <v-spacer></v-spacer>

    </v-toolbar>
    <v-tabs v-model="tab"  v-if="loaded">
        <v-tab>[[lang "script"]]</v-tab>
        <v-tab>[[lang "settings"]]</v-tab>
        <v-tab>[[lang "parameters"]]</v-tab>
        <v-tab v-if="develop">[[lang "sourcecode"]]</v-tab>
    </v-tabs>

     <v-tabs-items v-model="tab"  v-if="loaded">
       <v-tab-item>  
        1
       </v-tab-item>
       <v-tab-item >
         2
        </v-tab-item>
       <v-tab-item >
         3
        </v-tab-item>
        <v-tab-item >
         4
        </v-tab-item>

    </v-tabs-items>
    <dlg-error :show="error" :title="errtitle" @close="error = false"/>
  </v-container>
</script>

<script>
const Editor = Vue.component('editor', {
    template: '#editor',
    data: editorData,
    methods: {
        errmsg( title ) {
            this.errtitle = title;
            this.error = true;
        },
        load(scriptname) {
            // if (this.changed) Do you want to save the current project?
            this.loaded = false;
            axios
            .get('/api/script' + ( !!scriptname ? '?name='+scriptname : ''))
            .then(response => {
                if (response.data.error) {
                    this.errmsg(response.data.error);
                    return
                }
                this.script = response.data;
                this.loaded = true;
            })
            .catch(error => this.errmsg(error));
        } 
    },
    mounted: function() {
        let par = '';
        if (this.$route.query.scriptname) {
            par = this.$route.query.scriptname
        }
        if (!this.loaded || !!par) {
            this.load(par);
        }
    },
    computed: {
        script: {
            get() { return store.state.script },
            set(value) { store.commit('updateScript', value) }
        },
        changed: {
            get() { return store.state.changed },
            set(value) { store.commit('updateChanged', value) }
        },
        loaded: {
            get() { return store.state.loaded },
            set(value) { store.commit('updateLoaded', value) }
        },
    }
});

function editorData() {
    return {
      tab: null,
      develop: [[.Develop]],
      error: false,
      errtitle: '',
    }
}
</script>