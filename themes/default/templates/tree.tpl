<script type="text/x-template" id="treeitem">
    <li v-bind:class="[isactive ? 'cmd-active' : 'cmd']" >
        <div class="tree-item" v-on:click="toActive">
         <v-btn small icon @click="expand"><v-icon small class="mb-1 mr-1" 
         :color="color">{{ item.open ? 
                  'fa-folder-open' : 'fa-folder' }}</v-icon></v-btn>
         <v-text v-bind:class="[isactive ? 'enz-active' : '']" >{{ item.name }} {{item.active}} </v-text>
         <v-btn small v-show="isactive" icon @click.stop="newChild"><v-icon small class="mb-1 mx-2" 
         color="white">fa-plus-square</v-icon></v-btn>
         <div style="font-size: smaller; padding-left: 4px;color: #888;">{{item.desc}}</div>
        </div>
    <ul v-bind:class="[isactive ? 'sub-active' : 'sub']" v-if="item.children && item.children.length > 0" v-show="item.open">
      <treeitem v-for="(child, index) in item.children" :item="item.children[index]"></treeitem>
    </ul>
    <div class="folder-empty" v-if="isactive && !item.children && item.open">
       <v-btn color="primary" small class="mx-4 my-2"><v-icon small left>fa-plus</v-icon>New child</v-btn>
    </div>
    </li>
</script>

<script type="text/x-template" id="tree">
  <div style="max-width: 550px; min-width:450px;max-height: 100%;padding-right: 16px;">
    <div class="pb-2">
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-expand-arrows-alt</v-icon></v-btn>
       <v-btn small icon @click="" color="primary">
       <v-icon small @click="">fa-compress-arrows-alt</v-icon></v-btn>
       <v-btn color="primary" small class="mx-2" @click="newCommand"><v-icon small left>fa-plus</v-icon>[[lang "new"]]</v-btn>
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
    <ul class="folders" style="padding-left: 0px; max-height: calc(100% - 36px);overflow-y: auto;" v-if="list && list.length > 0" vxshow="folder.open">
      <treeitem v-for="(child,index) in list" :item="list[index]"></treeitem>
    </ul>
    <div class="folder-empty" v-else v-show="list && list.open">No Data</div>
    <dlg-commands :show="newcmd" @close="newcmd = false"></dlg-commands>
  </div>
</script>

<script>

Vue.component('treeitem', {
    template: '#treeitem',
    data: treeItemData,
    props: {
        item: Object,
    },
    methods: {
        newChild(e) {
            if (!this.item.open) {
               this.expand(e);
            }
            this.$parent.newCommand()
        },
        toActive(e) {
            if (this.active == this.item) {
               this.expand(e);
            } else {
                this.active = this.item;
            }
        },
        expand(e) {
            this.$set(this.item, 'open',  !this.item.open);
            if (this.active == this.item) {
                e.stopPropagation();
            }
        }
    },
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
        newCommand() {
            this.newcmd = true;
        }
    },
    computed: {
        cmds: function() { return store.state.list },
    },
    mounted: function() {
        this.$root.loadList();
    },
});

function treeData() {
    return {
        newcmd: false,
    }
}

</script>