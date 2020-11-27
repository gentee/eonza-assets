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

<script type="text/x-template" id="c-html">
    <div v-html="htmlval" style="display: flex; margin: 1rem 0rem;"></div>
</script>

<script type="text/x-template" id="c-button">
    <v-btn :color="(!!par.options.default ? 'primary': '')" style="text-transform: none;margin-right: 1rem;margin-bottom:8px;" @click="btnclick">{{par.title}}</v-btn>
</script>

<script type="text/x-template" id="c-singletext">
    <v-text-field  v-model="vals[par.name]" @input="change"
         :label="par.title" :options="par.options" :rules="[rules]"
    ></v-text-field>
</script>

<script type="text/x-template" id="c-password">
    <v-text-field v-model="vals[par.name]"
            :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'"
                :type="show1 ? 'text' : 'password'"
            :label="par.title"
             :options="par.options" :rules="[rules]"
            style="max-width: 300px;"
            hint="" 
            @click:append="show1 = !show1"
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
                         :is="PTypes[comp.type].comp" v-bind="{par:comp, vals: editedItem}"></component>
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

const PCheckbox = 0;
const PTextarea = 1;
const PSingleText = 2;
const PSelect = 3;
const PNumber = 4;
const PList = 5;
const PHTMLText = 6;
const PButton = 7;
const PDynamic = 8;
const PPassword = 9;

const PTypes = [
    {text: '%checkbox%', value: 0, comp: 'c-checkbox'},
    {text: '%textarea%', value: 1, comp: 'c-textarea'},
    {text: '%singletext%', value: 2, comp: 'c-singletext'},
    {text: '%select%', value: 3, comp: 'c-select'},
    {text: '%number%', value: 4, comp: 'c-number'},
    {text: '%list%', value: 5, comp: 'c-list'},
    {text: '%htmltext%', value: 6, comp: 'c-html'},
    {text: '%button%', value: 7, comp: 'c-button'},
    {text: '%dynamic%', value: 8, comp: ''},
    {text: '%password%', value: 9, comp: 'c-password'},
];//.sort((a,b) => (a.text > b.text) ? 1 : ((b.text > a.text) ? -1 : 0));

function removeScripts(input) {
    var div = document.createElement('div');
    div.innerHTML = input;
    let scripts = div.getElementsByTagName('script');
    let i = scripts.length;
    while (i--) {
      scripts[i].parentNode.removeChild(scripts[i]);
    }
    return div.innerHTML;
}

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
                    let cmp = ''
                    if (typeof this.par.options.items[i].value === 'undefined') {
                        cmp = this.par.options.items[i].title
                    } else {
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
                if (!!this.par.options.initial && (typeof this.vals[this.par.name] === 'undefined' ||
                    this.vals[this.par.name] == '' )) {
                    this.vals[this.par.name] = this.par.options.initial
                }       
                for (let i = 0; i < this.par.options.items.length;i++) {
                    let val = this.par.options.items[i].title
                    ret.push(val)
                    let cmp = val 
/*                    if (!!this.par.options.items[i].value) {
                        cmp = this.par.options.items[i].value
                    }*/
                    if (typeof this.par.options.items[i].value !== 'undefined') {
                        cmp = this.par.options.items[i].value
                    }
                    if (this.vals[this.par.name] == cmp || i==0 ) {
                        this.curItem = val
                        if (typeof this.vals[this.par.name] === 'undefined' || 
                            this.vals[this.par.name] == '' ) { 
                            // assign initial value
                            this.vals[this.par.name] = cmp
                        }
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

Vue.component('c-html', {
    template: '#c-html',
    computed: {
        htmlval() {
            return removeScripts(this.vals[this.par.name])
        }
    },
    props: {
        par: Object,
        vals: Object,
    },
});

Vue.component('c-button', {
    template: '#c-button',
    methods: {
        btnclick() {
            let value = true
            if (this.par.options && typeof this.par.options.initial !== 'undefined' ) {
                value = this.par.options.initial
            }
            this.$emit('btnclick', {name: this.par.name, value: value} );
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
            if (!this.vals[this.par.name] || !Array.isArray(this.vals[this.par.name])) {
                this.vals[this.par.name] = []
            }
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
            let val = item[par.name] || ''
            if (par.type == PCheckbox) {
                if (!!par.options.output) {
                    val = par.options.output[item[par.name] ? 1 : 0]
                }
            }
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
                if (!def) {
                  switch (list[i].type) {
                    case PCheckbox:
                      def = false
                      break
                    case PSelect:
                      let items = list[i].options.items
                      if (items && items.length > 0) {
                        def = items[0].value || items[0]
                      } else {
                        def = 0
                      }
                      break
                  }
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
            let item = Object.assign({}, this.editedItem)
            if (this.editedIndex > -1) {
                this.$set(this.vals[this.par.name], this.editedIndex, item)
            } else {
                this.vals[this.par.name].push(item);
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

Vue.component('c-password', {
    template: '#c-password',
    mixins: [changed],
    data() {return {
        show1: false,
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

</script>