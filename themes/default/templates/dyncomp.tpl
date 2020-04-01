<script type="text/x-template" id="c-checkbox">
    <v-checkbox v-model="active.values[par.name]"  @change="change"  style="margin: 0"
        :label="par.title"
    ></v-checkbox>
</script>

<script type="text/x-template" id="c-textarea">
    <v-textarea  v-model="active.values[par.name]" @input="change"
         :label="par.title" auto-grow dense
    ></v-textarea>
</script>

<script>
Vue.component('c-checkbox', {
    template: '#c-checkbox',
    mixins: [changed],
    data() {return {

        }
    },
    computed: {
//        cmds: () => { return store.state.list },
    },
    props: {
        par: Object,
    },
});

Vue.component('c-textarea', {
    template: '#c-textarea',
    mixins: [changed],
    data() {return {

        }
    },
    computed: {
//        cmds: () => { return store.state.list },
    },
    props: {
        par: Object,
    },
});
</script>