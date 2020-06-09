<script type="text/x-template" id="card">
    <div class="pl-6" v-if="active" style="max-height: 100%;overflow-y: auto;
         border-left: 2px solid #ddd;width: 100%;">
        <div style="font-weight: bold;" class="pa-3" :class="forcard" >{{title}}
        <v-icon @click="jumpto" color="primary" small style="float:right;">fa-external-link-alt</v-icon></div>
        <v-text-field v-model="active.values._desc"
        label="%desc%" @input="change"
        ></v-text-field>
        <component v-for="comp in cmds[active.name].params"
            :is="PTypes[comp.type].comp" v-bind="{par:comp}" />
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
    },
    methods: {
        jumpto() {
            this.$parent.load(this.active.name)
        }
    }
});
</script>