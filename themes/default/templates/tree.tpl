<script type="text/x-template" id="treeitem">
    <li v-bind:class="[isactive ? 'cmd-active' : '']" >
        <div class="tree-item" v-on:click="toActive">
         <v-btn small icon @click="expand"><v-icon small class="mb-1 mr-1" 
         :color="color">{{ icon }}</v-icon></v-btn>
         <v-text>{{ cmds[item.name].title }}</v-text>
         <v-tooltip bottom v-if="isfolder">
            <template v-slot:activator="{ on }">
         <v-btn small icon @click.stop="newChild" v-on="on"><v-icon small class="mb-1 mx-2" 
         color="white">fa-plus-square</v-icon></v-btn>
            </template>
           <span>[[lang "newchild"]]</span>
        </v-tooltip>

         <div style="font-size: smaller; padding-left: 4px;color: #888;">{{item.desc}}</div>
        </div>
    <ul v-bind:class="[isactive ? 'sub-active' : 'sub']" v-if="item.children && item.children.length > 0" v-show="item.open">
      <treeitem v-for="child in item.children" :item="child"></treeitem>
    </ul>
    <div v-if="!item.children && item.open && isactive">
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
                    :class="{'mx-2': !!btn.title}" v-on="on" 
                    :disabled="isDisable(btn)">
                    <v-icon small :left="btn.title">{{btn.icon}}</v-icon>{{btn.title}}</v-btn>
            </template>
           <span>{{btn.hint}}</span>
        </v-tooltip>
    </div>
    <ul class="folders" style="padding-left: 0px; max-height: calc(100% - 36px);overflow-y: auto;" v-if="obj.length > 0" vxshow="folder.open">
      <treeitem v-for="child in obj" :item="child"></treeitem>
    </ul>
    <!--div v-else>No Data</div-->
  </div>
</script>

<script>

const changed = {
  methods: {
    change() {
      if (!this.changed) {
        this.changed = true;
      }
    },
  },
  computed: {
    active: {
        get() { return store.state.active },
        set(value) { store.commit('updateActive', value) }
    },
    changed: {
        get() { return store.state.changed },
        set(value) { store.commit('updateChanged', value) }
    },
  }
}

Vue.component('treeitem', {
    template: '#treeitem',
    mixins: [changed],
    data: treeItemData,
    props: {
        item: Object,
    },
    methods: {
        newChild(e) {
            if (!this.item.open) {
               this.expand(e);
            }
            let comp = this;
            let cmds = this.cmds;
            let obj = this.active;
            this.$root.newCommand(function(par) {
                if (!!par && cmds[par]) {
                    let cmd = cmds[par];
                    let item = {
                        name: cmd.name,
                        __parent: obj,
                    }
                    if (!obj.children) {
                        obj.children = [];
                    }
                    obj.children.push(item);
                    comp.active = item;
                    comp.change();
                }
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
            if (!this.cmds[this.item.name].folder) {
                return;
            }
            this.$set(this.item, 'open',  !this.item.open);
            if (this.active == this.item) {
                e.stopPropagation();
            }
        }
    },
    computed: {
        cmds: () => { return store.state.list },
        icon() {
            const cmd = this.cmds[this.item.name]
            if (cmd && cmd.folder) {
                return this.item.open ? 'fa-folder-open' : 'fa-folder'
            }
            return 'fa-cog'
        },
        isactive() { 
            return this.item == this.active },
        isfolder() { 
            return this.item == this.active && this.cmds[this.item.name].folder },
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
    mixins: [changed],
    data: treeData,
    props: {
        obj: Array,
    },
    methods: {
        enumAll(parent, fn) {
            let list = this.obj;
            if (parent) {
                list = parent ? parent : [];
            }
            for (i=0; i<list.length; i++) {
                if (this.cmds[list[i].name].folder) {
                    if (list[i].children && list[i].children.length > 0) {
                        fn(list[i]);
                        this.enumAll(list[i].children, fn);
                    }
                }
            }
        },
        expandAll(parent) {
            this.enumAll(null, v => v.open = true);
            this.active = this.obj[0];
        },
        collapseAll(parent) {
            this.enumAll(null, v => v.open = false);
            this.active = this.obj[0];
        },
        isDisable(btn) {
            if (!btn.disable) return false;
            if (btn.disable & disActive && !this.active) {
                return true;
            }
            if (btn.disable & disClip && !this.clipboard) {
                return true;
            }
            let list = this.active.__parent ? this.active.__parent.children : this.obj;
            if (btn.disable & disFirst && this.active == list[0]) {
                return true;
            }
            if (btn.disable & disLast && this.active == list[list.length-1] ) {
                return true;
            }
            return false;
        },
        newCommand() {
            let comp = this;
            let cmds = this.cmds;
            let parent = this.active ? this.active.__parent : null;
            this.$root.newCommand(function(par) {
                if (!!par && cmds[par]) {
                    let cmd = cmds[par];
                    let item = {
                        name: cmd.name,
                        __parent: parent,
                    }
                    let list = []
                    if (parent) {
                        list = parent.children;
                    } else {
                        list = comp.obj;
                    }
                    if (!comp.active || comp.active == list[length-1]) {
                        list.push(item);
                    } else {
                        list.splice(list.indexOf(comp.active)+1, 0, item);
                    }
                    comp.active = item;
                    comp.change();
                }
            })
        },
    },
    computed: {
        cmds: () => { return store.state.list },
        clipboard: () => { return store.state.clipboard },
    },
    mounted: function() {
        this.$root.loadList();
    },
});

const disActive = 1
const disClip = 2
const disFirst = 4
const disLast = 8

function treeData() {
    return {
        btns: [
            {icon: 'fa-expand-arrows-alt', hint: [[lang "expandall"]], disable: disActive,
               click: this.expandAll },
            {icon: 'fa-compress-arrows-alt', hint: [[lang "collapseall"]], disable: disActive,
               click: this.collapseAll},
            {icon: 'fa-plus', hint: [[lang "addcmd"]], title: [[lang "new"]], click: this.newCommand },
            {icon: 'fa-angle-double-up', hint: [[lang "moveup"]], disable: disActive | disFirst},
            {icon: 'fa-angle-double-down', hint: [[lang "movedown"]], disable: disActive | disLast},
            {icon: 'fa-copy', hint: [[lang "copy"]], disable: disActive },
            {icon: 'fa-paste', hint: [[lang "paste"]], disable: disClip},
            {icon: 'fa-clone', hint: [[lang "dup"]], disable: disActive},
            {icon: 'fa-ban', hint: [[lang "disena"]], disable: disActive},
            {icon: 'fa-times', hint: [[lang "delete"]], disable: disActive},
        ]
    }
}

</script>