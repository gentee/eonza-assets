<script type="text/x-template" id="treeitem">
    <li v-bind:class="[isactive ? 'cmd-active' : 'cmd']" >
        <div class="tree-item" v-on:click="toActive">
         <v-btn small icon @click="expand"><v-icon small class="mb-1 mr-1" 
         :color="color">{{ item.open ? 
                  'fa-folder-open' : 'fa-folder' }}</v-icon></v-btn>
         <v-text v-bind:class="[isactive ? 'enz-active' : '']" >{{ item.name }} {{item.active}} </v-text>
         <v-tooltip bottom>
            <template v-slot:activator="{ on }">
         <v-btn small v-show="isactive" icon @click.stop="newChild" v-on="on"><v-icon small class="mb-1 mx-2" 
         color="white">fa-plus-square</v-icon></v-btn>
            </template>
           <span>[[lang "newchild"]]</span>
        </v-tooltip>

         <div style="font-size: smaller; padding-left: 4px;color: #888;">{{item.desc}}</div>
        </div>
    <ul v-bind:class="[isactive ? 'sub-active' : 'sub']" v-if="item.children && item.children.length > 0" v-show="item.open">
      <treeitem v-for="(child, index) in item.children" :item="item.children[index]"></treeitem>
    </ul>
    <div class="folder-empty" v-if="isactive && !item.children && item.open">
       <v-btn color="primary" small class="mx-4 my-2" @click="newChild" style="text-transform:none"><v-icon small left>fa-plus</v-icon>[[lang "newchild"]]</v-btn>
    </div>
    </li>
</script>

<script type="text/x-template" id="tree">
  <div style="max-width: 550px; min-width:450px;max-height: 100%;padding-right: 16px;">
    <div class="pb-2">
        <v-tooltip top v-for="btn in btns">
            <template v-slot:activator="{ on }">
                <v-btn small :icon="!btn.title" @click=btn.click color="primary"
                    :class="{'mx-2': !!btn.title}"
                    :disabled="(btn.active && !active) || (btn.clip && !clipboard)" v-on="on">
                    <v-icon small :left="btn.title">{{btn.icon}}</v-icon>{{btn.title}}</v-btn>
            </template>
           <span>{{btn.hint}}</span>
        </v-tooltip>
    </div>
    <ul class="folders" style="padding-left: 0px; max-height: calc(100% - 36px);overflow-y: auto;" v-if="list && list.length > 0" vxshow="folder.open">
      <treeitem v-for="(child,index) in list" :item="list[index]"></treeitem>
    </ul>
    <div class="folder-empty" v-else v-show="list && list.open">No Data</div>
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
            this.$root.newCommand(function(par) {
                console.log('get', par)
            })
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
            this.$root.newCommand(function(par) {
                console.log('get', par)
            })
        },
    },
    computed: {
        cmds: () => { return store.state.list },
//        active: () => { return store.state.active },
        active: {
            get() { return store.state.active },
            set(value) { store.commit('updateActive', value) }
        },
        clipboard: () => { return store.state.clipboard },
    },
    mounted: function() {
        this.$root.loadList();
    },
});

function treeData() {
    return {
        btns: [
            {icon: 'fa-expand-arrows-alt', hint: [[lang "expandall"]], active: true},
            {icon: 'fa-compress-arrows-alt', hint: [[lang "collapseall"]], active: true},
            {icon: 'fa-plus', hint: [[lang "addcmd"]], title: [[lang "new"]], click: this.newCommand },
            {icon: 'fa-angle-double-up', hint: [[lang "moveup"]], active: true},
            {icon: 'fa-angle-double-down', hint: [[lang "movedown"]], active: true},
            {icon: 'fa-copy', hint: [[lang "copy"]], active: true, click: this.test},
            {icon: 'fa-paste', hint: [[lang "paste"]], clip: true},
            {icon: 'fa-clone', hint: [[lang "dup"]], active: true},
            {icon: 'fa-ban', hint: [[lang "disena"]], active: true},
            {icon: 'fa-times', hint: [[lang "delete"]], active: true},
        ]
    }
}

</script>