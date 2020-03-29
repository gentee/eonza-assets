<script type="text/x-template" id="treeitem">
    <li v-bind:class="[isactive ? 'cmd-active' : '']" >
        <div class="tree-item" v-on:click="toActive">
         <v-btn small icon @click="expand"><v-icon small class="mb-1 mr-1" 
         :color="color">{{ icon() }}</v-icon></v-btn>
         <v-text :class="[item.disable ? 'ban' : '' ]">{{ cmds[item.name].title }}<small>{{ count() }}</small></v-text>
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
    <div v-if="!item.children && item.open && isactive" class="d-flex">
       <v-btn color="primary" small class="mx-4 my-2" @click="newChild" style="text-transform:none"><v-icon small left>fa-plus</v-icon>[[lang "newchild"]]</v-btn>
       <v-btn v-if="clipboard" icon color="primary" small class="mx-4 my-2" @click="pasteChild"><v-icon small>fa-paste</v-icon></v-btn>
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
        addChild( item ) {
            item.__parent = this.item;
            if (!this.item.children) {
                this.item.children = [];
            }
            this.item.children.push(item)
            this.active = item;
            this.change();
        },
        pasteChild() {
            if (!this.clipboard || this.active != this.item || (this.item.children && 
                 this.item.children.length > 0)) {
                return
            }
            let item = clone(this.clipboard);
            addsysinfo(item.children, item)
            this.addChild(item)
        },
        newChild(e) {
            if (!this.item.open) {
               this.expand(e);
            }
            let comp = this;
            this.$root.newCommand(function(par) {
                if (!!par && comp.cmds[par]) {
                    comp.addChild({
                        name: comp.cmds[par].name,
                    })
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
            this.$forceUpdate();
        },
        count() {
            if (this.item.children && this.item.children.length > 0) {
                return ` (${this.item.children.length})`
            }
            return '';
        },
        icon() {
            if (this.item.disable) {
                return 'fa-ban'
            }
            const cmd = this.cmds[this.item.name]
            if (cmd && cmd.folder) {
                return this.item.open ? 'fa-folder-open' : 'fa-folder'
            }
            return 'fa-cog'
        },
    },
    computed: {
        cmds: () => { return store.state.list },
        clipboard: () => { return store.state.clipboard  },
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
        enumAll(list, fn) {
            for (let i=0; i<list.length; i++) {
                if (this.cmds[list[i].name].folder) {
                    if (list[i].children && list[i].children.length > 0) {
                        fn(list[i]);
                        this.enumAll(list[i].children, fn);
                    }
                }
            }
        },
        expandAll(parent) {
            this.enumAll(this.obj, v => v.open = true);
            this.$forceUpdate();
            this.active = this.obj[0];
        },
        collapseAll(parent) {
            this.enumAll(this.obj, v => v.open = false);
            this.$forceUpdate();
            this.active = this.obj[0];
        },
        move(direct) {
            let list = this.obj;
            if (this.active.__parent) {
                list = this.active.__parent.children
            }
            index = list.indexOf(this.active)
            if ((direct < 0 && index>0) || (direct > 0 && index < list.length-1) ) 
            {
                const tmp = list[index+direct];
                this.$set(list, index+direct, list[index]);
                this.$set(list, index, tmp);
            }
            this.change()
        },
        moveUp() {
            this.move(-1);
        },
        moveDown() {
            this.move(1);
        },
        copy() {
            if (this.active) {
                this.clipboard = clone(this.active);
            }
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
        addItem(item) {
            let parent = this.active ? this.active.__parent : null;
            let list = []
            if (parent) {
                list = parent.children;
            } else {
                list = this.obj;
            }
            item.__parent = parent;
            if (!this.active || this.active == list[list.length-1]) {
                list.push(item);
            } else {
                list.splice(list.indexOf(this.active)+1, 0, item);
            }
            this.active = item;
            this.change();
        },
        paste() {
            if (!this.clipboard) {
                return
            }
            let item = clone(this.clipboard)
            addsysinfo(item.children, item)
            this.addItem(item)
        },
        dup() {
            if (!this.active) {
                return;
            }
            let item = clone(this.active)
            addsysinfo(item.children, item)
            this.addItem(item)
        },
        newCommand() {
            let comp = this;
            this.$root.newCommand(function(par) {
                if (!!par && comp.cmds[par]) {
                    comp.addItem({
                        name: comp.cmds[par].name,
                    })
                }
            })
        },
        disable() {
            if (this.active) {
                this.$set(this.active, 'disable',  !this.active.disable);
                this.change();
            }
        },
        del() {
            if (this.active) {
                let comp = this;
                this.$root.confirm( [[lang "delconfirm"]], 
                function( par ){
                    comp.$root.question = false;
                    if (par == btn.Yes) {
                        let owner = comp.active.__parent
                        let parent = owner ? owner.children : comp.obj
                        let index = parent.indexOf(comp.active)
                        if (index>=0) {
                            parent.splice(index, 1)
                            if (index < parent.length ) {
                                comp.active = parent[index]
                            } else if (index > 0) {
                                comp.active = parent[index-1]
                            } else if ( owner ){
                                comp.active = owner
                            } else {
                                comp.active = null
                            }
                            comp.change();
                        }
                    }
                }); 
            }
        }
    },
    computed: {
        cmds: () => { return store.state.list },
        clipboard: {
            get() { return store.state.clipboard  },
            set(value) { store.commit('updateClipboard', value) }
        },
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
            {icon: 'fa-angle-double-up', hint: [[lang "moveup"]], disable: disActive | disFirst,
              click: this.moveUp},
            {icon: 'fa-angle-double-down', hint: [[lang "movedown"]], 
              disable: disActive | disLast, click: this.moveDown},
            {icon: 'fa-copy', hint: [[lang "copy"]], disable: disActive, click: this.copy },
            {icon: 'fa-paste', hint: [[lang "paste"]], disable: disClip, click: this.paste },
            {icon: 'fa-clone', hint: [[lang "dup"]], disable: disActive, click: this.dup },
            {icon: 'fa-ban', hint: [[lang "disena"]], disable: disActive, click: this.disable}, 
            {icon: 'fa-times', hint: [[lang "delete"]], disable: disActive, click: this.del},
        ]
    }
}

</script>