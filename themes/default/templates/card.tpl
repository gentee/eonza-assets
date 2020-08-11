<script type="text/x-template" id="card">
    <div class="pl-6" v-if="active" style="max-height: 100%;overflow-y: auto;
         border-left: 2px solid #ddd;width: 100%;">
        <div style="font-weight: bold;" class="pa-3" :class="forcard" >{{title}}
        <v-btn color="light-blue darken-1" v-if="help" dark small target="_help" :href=gethelp style="float:right;text-transform:none" class="ml-2"><v-icon small>fa-question-circle</v-icon>&nbsp;Help</v-btn>
        <v-btn color="light-blue darken-1" dark small @click="jumpto"  style="float:right;"><v-icon @click="jumpto" small>fa-external-link-alt</v-icon></v-btn></div>
        <v-text-field v-model="active.values._desc"
        label="%desc%" @input="change"
        ></v-text-field>
        <component v-for="comp in cmds[active.name].params"
            :is="PTypes[comp.type].comp" v-bind="{par:comp, vals:active.values}"></component>
    </div>
</script>

<script>
Vue.component('card', {
    template: '#card',
    mixins: [changed],
    computed: {
        cmds: () => { return store.state.list },
        forcard() { return this.active.disable ? 'cardd' : 'card' },
        title() { return this.cmds[this.active.name].title },
        help() { return this.cmds[this.active.name].help },
        gethelp() { 
            let cmd = this.cmds[this.active.name]
            let langs = []
            let pref = ''
            if (!!cmd.helplang) {
                langs = cmd.helplang.split(',')
            }
            for (let i=0; i < langs.length; i++) {
                if (langs[i]== [[.Lang]] ) {
                    pref = langs[i] + '/'
                }
            }
            return "https://www.eonza.org/" + pref +  "scripts/" + cmd.help + ".html"
        },
    },
    methods: {
        jumpto() {
            this.$parent.load(this.active.name)
        }
    }
});
</script>