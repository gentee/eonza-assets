<script type="text/x-template" id="treeitem">
    <li class="folder" vxbind:class="[folder.leaf ? 'is-leaf' : 'is-folder']">
         <span vxon:click="expand()">{{ item.name }}</span>

    <ul class="sub-folders" v-if="item.children && item.children.length > 0" vxshow="folder.expanded">
      <treeitem v-for="child in item.children" v-bind:item="child"></treeitem>
    </ul>
    <div class="folder-empty" v-else v-show="!item.leaf && item.expanded">No Data</div>
    </li>
</script>

<script type="text/x-template" id="tree">
  <v-container style="max-width: 550px; min-width:300px;borderx: 1px solid #000;">
    <ul class="sub-folders" v-if="list && list.length > 0" vxshow="folder.expanded">
      <treeitem v-for="child in list" v-bind:item="child"></treeitem>
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
    },
/*    components: {
        'item': list
    },*/
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
/*    components: {
        'item': list
    },*/
    mounted: function() {
    },
});

function treeData() {
    return {
    }
}

</script>