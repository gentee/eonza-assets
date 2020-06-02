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
    <v-select @change="changeItem"
        v-model="curItem"
        :items="items"
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
            curItem: null,
        }
    },
    methods: {
        changeItem() {
            for (let i = 0; i < this.par.options.items.length;i++) {
                if (this.curItem == this.par.options.items[i].title) {
                    let cmp = this.par.options.items[i].title
                    if (!!this.par.options.items[i].value) {
                        cmp = this.par.options.items[i].value
                    }
                    this.active.values[this.par.name] = cmp
                }
            }
            this.change()
        }
    },
     computed: {
        items() { 
            let ret = []
            console.log(this.active.values[this.par.name])
            if (this.par.options) {
                for (let i = 0; i < this.par.options.items.length;i++) {
                    let val = this.par.options.items[i].title
                    ret.push(val)
                    let cmp = val 
                    if (!!this.par.options.items[i].value) {
                        cmp = this.par.options.items[i].value
                    }
                    if (this.active.values[this.par.name] == cmp || i==0 ) {
                        this.curItem = val
                    }
                }
            }
            return ret
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
            if (this.par.options.required && !value) {
                return [[lang "required"]]
            }
            return true
        },
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
            if (this.par.options.required && !value) {
                return [[lang "required"]]
            }
            return true
        },
      }
    },
    props: {
        par: Object,
    },
});

</script>