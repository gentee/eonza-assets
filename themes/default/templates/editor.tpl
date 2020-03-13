<script type="text/x-template" id="editor">
  <v-container fluid>
  <v-toolbar dense flat=true>
      <v-toolbar-title>{{script.settings.title}}</v-toolbar-title>
      <v-spacer></v-spacer>
        <v-menu bottom left>
            <template v-slot:activator="{ on: history }">
               <v-tooltip bottom>
                <template v-slot:activator="{ on: tooltip }">
                    <v-btn
                        icon
                        color="primary"
                        v-on="{ ...tooltip, ...history }"
                        :disabled="!script.history"
                    >
                        <v-icon>fa-history</v-icon>
                    </v-btn>
                </template>
                <span>[[lang "history"]]</span>
                </v-tooltip>
            </template>
            <v-list dense>
              <v-list-item
                v-for="(item, i) in script.history"
                :key="i"
                @click="load(item.name)"
              >
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        <v-btn color="primary" class="mx-2" @click="load('new')" >
            <v-icon left>fa-plus</v-icon>&nbsp;[[lang "newscript"]]
        </v-btn>
        <v-btn color="primary" class="mx-2" :disabled="!changed" @click="this.$root.saveScript">
            <v-icon left>fa-save</v-icon>&nbsp;[[lang "save"]]
        </v-btn>
        <v-btn color="primary" class="mx-2"  v-if="loaded">
            <v-icon left>fa-play</v-icon>&nbsp;[[lang "run"]]
        </v-btn>
        <v-btn color="primary" class="mx-2" v-if="loaded">
            <v-icon>fa-caret-down</v-icon>&nbsp;[[lang "menu"]]
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
       <v-tab-item>
        <v-container>
          <v-text-field v-model="script.settings.name" @change="ischanged"
           label="[[lang "uniquename"]]" counter maxlength="32" hint="a-z, 0-9, .-_"
            :rules="[rules.required, rules.unique]"></v-text-field>
          <v-text-field v-model="script.settings.title" @change="ischanged"
          label="[[lang "title"]]" counter maxlength="64" :rules="[rules.required]"
        ></v-text-field>
        </v-container>
        </v-tab-item>
       <v-tab-item >
         3
        </v-tab-item>
        <v-tab-item >
         4
        </v-tab-item>

    </v-tabs-items>
    <dlg-error :show="error" :title="errtitle" @close="error = false"></dlg-error>
  </v-container>
</script>

<script>
const Editor = Vue.component('editor', {
    template: '#editor',
    data: editorData,
    methods: {
        ischanged() {
            if (!this.changed) {
                this.changed = true;
            }
        },
        errmsg( title ) {
            this.errtitle = title;
            this.error = true;
        },
        open() {
            this.loaded = false;
            axios
            .get('/api/script' + ( !!this.toopen ? '?name='+this.toopen : ''))
            .then(response => {
                if (response.data.error) {
                    this.errmsg(response.data.error);
                    return
                }
                if (!!response.data.history) {
                    response.data.history = response.data.history.filter( 
                           (i) => i.name != response.data.settings.name );
                }
                this.script = response.data;
                this.loaded = true;
            })
            .catch(error => this.errmsg(error));
        },
        load(scriptname) {
            this.toopen = scriptname;
            this.$root.checkChanged(this.open);
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
        toopen: '',
        rules: {
          required: value => !!value || [[lang "required"]],
          unique: value => {
            const pattern = /^[a-z\d\._-]+$/
            return pattern.test(value) || [[lang "invalidvalue"]]
          },
        },
    }
}
</script>