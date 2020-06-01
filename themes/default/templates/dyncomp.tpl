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

<script type="text/x-template" id="c-select">
    <v-select @change="change"
        v-model="active.values[par.name]"
        :items="par.options.items"
        :label="par.title"
    ></v-select>
</script>


<script>
Vue.component('c-checkbox', {
    template: '#c-checkbox',
    mixins: [changed],
    data() {return {
        }
    },
    props: {
        par: Object,
    },
});

Vue.component('c-select', {
    template: '#c-select',
    mixins: [changed],
    data() {return {

        }
    },
    mounted() {
        if (this.par.options) {
            this.options.required = !!this.par.options.required
        }
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
            this.options.required = !!this.par.options.required
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
            this.options.required = !!this.par.options.required
        }
    },
    props: {
        par: Object,
    },
});

</script>