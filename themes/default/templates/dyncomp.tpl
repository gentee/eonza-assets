<script type="text/x-template" id="c-checkbox">
    <v-checkbox v-model="vals[par.name]"  @change="change"  style="margin: 0"
        :label="par.title"
    ></v-checkbox>
</script>

<script type="text/x-template" id="c-textarea">
    <v-textarea  v-model="vals[par.name]" @input="change"
         :label="par.title" :options="par.options" auto-grow dense :rules="[rules]"
    ></v-textarea>
</script>

<script type="text/x-template" id="c-singletext">
    <v-text-field  v-model="vals[par.name]" @input="change"
         :label="par.title" :options="par.options" :rules="[rules]"
    ></v-text-field>
</script>

<script type="text/x-template" id="c-number">
    <v-text-field  v-model="vals[par.name]" @input="change"
         :label="par.title" :options="par.options" :rules="[rules]"
         type="number">
    </v-text-field>
</script>

<script type="text/x-template" id="c-select">
    <v-select @change="changeItem"
        v-model="curItem"
        :items="items"
        :label="par.title"
    ></v-select>
</script>

<script type="text/x-template" id="c-list">
        <v-data-table
          disable-filtering disable-pagination disable-sort hide-default-footer
          :headers="headParams"
          :items="items"
        >
          <template v-slot:top>
              <v-dialog v-model="dlgParams" max-width="600px">
                <template v-slot:activator="{ on }">
                  <span class="mr-3"><strong>{{par.title}}</strong></span>
                  <v-btn color="primary" dark class="mb-2" v-on="on" @click="newParam">%newitem%</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ dlgParamTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                     <component v-for="comp in par.options.list"
                         :is="PTypes[comp.type].comp" v-bind="{par:comp, vals: editedItem}" />
                    </v-container>
                  </v-card-text>

                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn class="ma-2" color="primary" @click="saveParams">%save%</v-btn>
                    <v-btn class="ma-2" color="primary" text outlined  @click="closeParams">%cancel%</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
          </template>
          <template v-slot:body="{ items }">
              <tbody>
                <tr v-for="(item, index) in items" :key="item.name">

                  <td v-for="ipar in par.options.list">{{ out(item,ipar) }}</td>
                  <td><span @click="editParams(index)" class="mr-2">
                      <v-icon small @click="">fa-pencil-alt</v-icon>
                      </span>
                      <span @click="moveParams(index, -1)" class="mr-2" v-show="index>0">
                      <v-icon small @click="">fa-angle-double-up</v-icon></span>
                      <span @click="moveParams(index, 1)" class="mr-2" v-show="index<items.length-1">
                      <v-icon small @click="">fa-angle-double-down</v-icon></span>
                      <span @click="deleteParams(index)" class="mr-2">
                      <v-icon small @click="">fa-times</v-icon></span>
                  </td>
                </tr>
              </tbody>
            </template>
          <!--template v-slot:no-data>
            <v-btn color="primary" click="initialize">%newitem%</v-btn>
          </template-->
        </v-data-table>
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
        vals: Object,
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
                    this.vals[this.par.name] = cmp
                }
            }
            this.change()
        }
    },
     computed: {
        items() { 
            let ret = []
            if (this.par.options) {
                for (let i = 0; i < this.par.options.items.length;i++) {
                    let val = this.par.options.items[i].title
                    ret.push(val)
                    let cmp = val 
                    if (!!this.par.options.items[i].value) {
                        cmp = this.par.options.items[i].value
                    }
                    if (this.vals[this.par.name] == cmp || i==0 ) {
                        this.curItem = val
                    }
                }
            }
            return ret
        }
    },
    props: {
        par: Object,
        vals: Object,
    },
});

Vue.component('c-textarea', {
    template: '#c-textarea',
    mixins: [changed],
    data() {return {
        options: {},
        rules: value => {
            if (this.par.options.required && !value) {
                return '%required%'
            }
            return true
        },
      }
    },
    props: {
        par: Object,
        vals: Object,
    },
});

Vue.component('c-singletext', {
    template: '#c-singletext',
    mixins: [changed],
    data() {return {
        options: {},
        rules: value => {
            if (this.par.options.required && !value) {
                return '%required%'
            }
            return true
        },
      }
    },
    props: {
        par: Object,
        vals: Object,
    },
});

Vue.component('c-number', {
    template: '#c-number',
    mixins: [changed],
    data() {return {
        options: {},
        rules: value => {
            if (this.par.options.required && !value) {
                return '%required%'
            }
            return true
        },
      }
    },
    methods: {
    },
    props: {
        par: Object,
        vals: Object,
    },
});

Vue.component('c-list', {
    template: '#c-list',
    mixins: [changed],
    data() {return {
        dlgParams: false,
        editedIndex: -1,
        editedItem: {},
      }
    },
    computed: {
        items() {
            return this.vals[this.par.name]
        },
       headParams() {
           return [...this.par.options.list.map((n) => {return {text: n.title, value: n.name }}), 
           {text: '%actions%', value: '' }]
        },
       dlgParamTitle () {
            return this.editedIndex === -1 ? '%newitem%' : '%edititem%'
        },
    },
    methods: {
        out(item, par) { 
            let val = item[par.name] 
            if (par.type == PSelect) {
                for (let i = 0; i < par.options.items.length; i++ ) {
                    if (par.options.items[i].value == val) {
                        val = par.options.items[i].title
                        break
                    }
                }
            }
            if (val.length > 32) {
                val = val.substr(0,32) + '...'
            }
            return val
        },
        editParams (index) {
            this.editedIndex = index
            this.editedItem = Object.assign({}, this.vals[this.par.name][index])
            this.dlgParams = true
        },
        newParam() {
            let list = this.par.options.list
            for (let i = 0; i < list.length; i++ ) {
                let def = list[i].options.initial || ''
                if (!def && list[i].type == PSelect) {
                    def = 0
                }
                this.editedItem[list[i].name] = def
            }
        },
        closeParams () {
            this.dlgParams = false
            this.editedIndex = -1
            this.editedItem = {}
        },
        deleteParams (index) {
            let comp = this;
            this.$root.confirmYes( '%delconfirm%', 
            function(){
                comp.vals[comp.par.name].splice(index, 1)
                comp.change()
           });               
        },
        moveParams (index, direct) {
            const tmp = this.vals[this.par.name][index+direct];
            this.$set(this.vals[this.par.name], index+direct, this.vals[this.par.name][index]);
            this.$set(this.vals[this.par.name], index, tmp);
            this.change()
        },
        saveParams () {
            if (this.editedIndex > -1) {
                this.$set(this.vals[this.par.name], this.editedIndex, Object.assign({}, this.editedItem))
            } else {
                this.vals[this.par.name].push(this.editedItem);
            }
            this.change()
            this.closeParams()
        },
    },
    watch: {
      dlgParams (val) {
        val || this.closeParams()
      },
    },
    props: {
        par: Object,
        vals: { type: Array, default: [] }
    },
});

</script>