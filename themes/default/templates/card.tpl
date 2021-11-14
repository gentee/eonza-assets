<script type="text/x-template" id="card">
    <div class="pl-6" v-if="active" style="max-height: 100%;overflow-y: auto;
         border-left: 2px solid #ddd;width: 100%;">
        <div style="font-weight: bold;" class="pa-3" :class="forcard" >{{title}}
        <v-btn color="light-blue darken-1" v-if="help" dark small target="_help" :href=gethelp style="float:right;text-transform:none" class="ml-2"><v-icon small>fa-question-circle</v-icon>&nbsp;Help</v-btn>
        <v-btn color="light-blue darken-1" dark small @click="jumpto"  style="float:right;"><v-icon  small>fa-external-link-alt</v-icon></v-btn></div>
        <div style="margin-bottom: 1.5rem;">
        <v-expansion-panels v-model="panel">
           <v-expansion-panel>
              <v-expansion-panel-header>
                 %commonsettings%
                <template v-slot:actions>
                   <v-icon color="primary">fa-angle-down</v-icon>
                 </template>
              </v-expansion-panel-header>
              <v-expansion-panel-content>
        <v-text-field v-model="active.values._desc" label="%desc%" @input="change"></v-text-field>
        <v-text-field v-model="active.values._ifcond" label="%ifcond%" @input="change"></v-text-field>

        <div>
            <div><strong>%advsettings%</strong><v-btn v-show="!advedit" color="light-blue darken-1" dark small @click="advancededit"  style="float:right;text-transform:none;"><v-icon small>fa-edit</v-icon>&nbsp;%edit%</v-btn>
            <v-btn v-show="advedit" color="light-blue darken-1" dark small @click="advedit=false"  style="float:right;text-transform:none;"><v-icon small>fa-times</v-icon>&nbsp;%cancel%</v-btn>
            <v-btn v-show="advedit" color="light-blue darken-1" dark small @click="advancedsave"  style="float:right;text-transform:none;margin-right: 1rem;"><v-icon small>fa-check</v-icon>&nbsp;%ok%</v-btn>
            </div>
            <pre v-show="!!active.values._advanced && !advedit" style="margin-top: 1rem;">{{active.values._advanced}}</pre>
            <v-textarea v-show="advedit" v-model="advtemp" auto-grow></v-textarea>
        </div>


              </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
        </div>
        <component v-for="comp in cmds[active.name].params"
            :is="PTypes[comp.type].comp" v-bind="{par:comp, vals:active.values}"></component>
        <div v-if="optional">
            <div><strong>%optionalpar%</strong><v-btn v-show="!optedit" color="light-blue darken-1" dark small @click="optionaledit"  style="float:right;text-transform:none;"><v-icon small>fa-edit</v-icon>&nbsp;%edit%</v-btn>
            <v-btn v-show="optedit" color="light-blue darken-1" dark small @click="optedit=false"  style="float:right;text-transform:none;"><v-icon small>fa-times</v-icon>&nbsp;%cancel%</v-btn>
            <v-btn v-show="optedit" color="light-blue darken-1" dark small @click="optionalsave"  style="float:right;text-transform:none;margin-right: 1rem;"><v-icon small>fa-check</v-icon>&nbsp;%ok%</v-btn>
            </div>
            <pre v-show="!!active.values._optional && !optedit" style="margin-top: 1rem;">{{active.values._optional}}</pre>
            <v-textarea v-show="optedit" v-model="opttemp" auto-grow></v-textarea>
        </div>

    </div>
</script>

<script>
Vue.component('card', {
    template: '#card',
    mixins: [changed],
    data() {return {
        panel: null,
        optedit: false,
        advedit: false,
        opttemp: '',
        advtemp: '',
      }
    },
    computed: {
        cmds: () => { return store.state.list },
        forcard() { return this.active.disable ? 'cardd' : 'card' },
        title() { return this.cmds[this.active.name].title },
        help() { return this.cmds[this.active.name].help },
        optional() { return this.cmds[this.active.name].optional },
        gethelp() { 
            let cmd = this.cmds[this.active.name]
            if (!cmd.help) {
                return '';
            }
            let ref = prefLang(cmd.helplang);
            if (cmd.help[0] == '@') {
                ref += "packages/" + cmd.help.substr(1)
            } else {
                ref += "scripts/" + cmd.help
            }
            return "https://www.eonza.org/" + ref + ".html"
        },
    },
    methods: {
        optionalsave() {
            this.optedit = false
            if (this.active.values._optional != this.opttemp) {
                this.change()
                this.active.values._optional = this.opttemp
            }
        },
        optionaledit() {
            this.optedit = true
            this.opttemp = this.active.values._optional || ''
        },
        advancedsave() {
            this.advedit = false
            if (this.active.values._advanced != this.advtemp) {
                this.change()
                this.active.values._advanced = this.advtemp
            }
        },
        advancededit() {
            this.advedit = true
            this.advtemp = this.active.values._advanced || ''
        },
        jumpto() {
            this.$parent.load(this.active.name)
        }
    },
    watch: {
        active(newval) {
            this.optedit = false
            this.advedit = false
            this.panel = (!!this.active && !!this.active.values && (!!this.active.values._ifcond ||
                !!this.active.values._advanced ) ? 0 : null)
        }
    }
});
</script>