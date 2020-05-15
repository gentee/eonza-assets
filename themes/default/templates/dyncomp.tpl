<script type="text/x-template" id="c-checkbox">
    <v-checkbox v-model="active.values[par.name]"  @change="change"  style="margin: 0"
        :label="par.title"
    ></v-checkbox>
</script>

<script type="text/x-template" id="c-textarea">
    <v-textarea  v-model="active.values[par.name]" @input="change"
         :label="par.title" :options="par.options" auto-grow dense :rules="[rules]"
    ></v-textarea>
</script>

<script type="text/x-template" id="c-singletext">
    <v-text-field  v-model="active.values[par.name]" @input="change"
         :label="par.title" :options="par.options" :rules="[rules]"
    ></v-text-field>
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
        options: {},
        rules: value => {
            if (this.options.required && !value) {
                return [[lang "required"]]
            }
            return true
        },
      }
    },
    mounted() {
        if (this.par.options) {
            let list = this.par.options.split(/\r?\n/)
            for (let i = 0; i < list.length; i++) {
                let pval = list[i].trim().split(':')
                if (pval.length == 2) {
                    let name = pval[0].trim()
                    switch (name) {
                        case 'required':
                           this.options.required = !!pval[1]
                    }
                }
            }
        }
    },
    props: {
        par: Object,
    },
});

Vue.component('c-singletext', {
    template: '#c-singletext',
    mixins: [changed],
    data() {return {
        options: {},
        rules: value => {
            if (this.options.required && !value) {
                return [[lang "required"]]
            }
            return true
        },
      }
    },
    mounted() {
        if (this.par.options) {
            let list = this.par.options.split(/\r?\n/)
            for (let i = 0; i < list.length; i++) {
                let pval = list[i].trim().split(':')
                if (pval.length == 2) {
                    let name = pval[0].trim()
                    switch (name) {
                        case 'required':
                           this.options.required = !!pval[1]
                    }
                }
            }
        }
    },
    props: {
        par: Object,
    },
});

</script>