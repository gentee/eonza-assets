<script type="text/x-template" id="treeitem">
    <li v-bind:class="[isactive ? 'cmd-active' : 'cmd']" >
        <div class="tree-item" v-on:click="toActive">
         <v-btn small icon @click="expand"><v-icon small class="mb-1 mr-1" 
         :color="color">{{ item.expanded ? 
                  'fa-folder-open' : 'fa-folder' }}</v-icon></v-btn>
         <span v-bind:class="[isactive ? 'enz-active' : '']" >{{ item.name }} {{item.active}} </span>
         <div style="font-size: smaller; padding-left: 4px;color: #888;">{{item.desc}}</div>
        </div>
    <ul v-bind:class="[isactive ? 'sub-active' : 'sub']" v-if="item.children && item.children.length > 0" v-show="item.expanded">
      <treeitem v-for="(child, index) in item.children" :item="item.children[index]"  :qqq="`subtest`"></treeitem>
    </ul>
    <div class="folder-empty" v-else v-show="!item.leaf && item.expanded">No Data</div>
    </li>
</script>

<script type="text/x-template" id="tree">
  <v-container style="max-width: 550px; min-width:300px;borderx: 1px solid #000;">
    <div class="pb-2">
       <v-btn color="primary" small class="mr-2"><v-icon small left>fa-plus</v-icon>New</v-btn><v-btn color="primary" small class="mr-2"><v-icon small left>fa-plus-square</v-icon>New Child</v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-angle-up</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-angle-down</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-copy</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-paste</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-clone</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-ban</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-times</v-icon></v-btn>
    </div>
    <ul class="folders" style="padding-left: 0px;" v-if="list && list.length > 0" vxshow="folder.expanded">
      <treeitem v-for="(child,index) in list" :item="list[index]" :qqq="my"></treeitem>
    </ul>
    <div class="folder-empty" v-else v-show="!list.leaf && list.expanded">No Data</div>
  </v-container>
</script>

<script>

Vue.component('treeitem', {
    template: '#treeitem',
    data: treeItemData,
    props: {
        item: Object,
        qqq: {
            type: String,
            default: 'OOOPS'
        }
    },
    methods: {
        toActive(e) {
            if (this.active == this.item) {
               this.expand(e);
            } else {
                this.active = this.item;
            }
        },
        expand(e) {
            this.item.expanded = !this.item.expanded
            this.$forceUpdate();
            if (this.active == this.item) {
                e.stopPropagation();
            }
        }
    },
/*    components: {
        'item': list
    },*/
    computed: {
        active: {
            get() { return store.state.active },
            set(value) { store.commit('updateActive', value) }
        },
        isactive() { 
            return this.item == this.active },
        color() {
            return this.isactive ? 'white' : 'grey darken-1';
        },
    },
    mounted: function() {
//        this.qqq = 'aaa';
//        console.log('item', this.active, this.item, this.active == this.item);
    }
});

function treeItemData() {
    return {
    }
}

Vue.component('tree', {
    template: '#tree',
    data: treeData,
    props: {
        list: Array,
    },
    methods: {
    },
/*    components: {
        'item': list
    },*/
    mounted: function() {
//        this.my = 'mmm';
//        this.setactive();
    },
});

function treeData() {
    return {
        my: 'bbb'
//        active: null,
    }
}

</script>