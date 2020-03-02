<script type="text/x-template" id="editor">
  <v-container fluid>
  <v-tabs v-model="tab">
        <v-tab>[[lang "script"]]</v-tab>
        <v-tab>[[lang "settings"]]</v-tab>
        <v-tab>[[lang "parameters"]]</v-tab>
        <v-tab v-if="develop">[[lang "sourcecode"]]</v-tab>
    </v-tabs>

     <v-tabs-items v-model="tab">
       <v-tab-item>  
        1
       </v-tab-item>
       <v-tab-item >
         2
        </v-tab-item>
       <v-tab-item >
         3
        </v-tab-item>
        <v-tab-item >
         4
        </v-tab-item>

    </v-tabs-items>

  </v-container>
</script>

<script>
const Editor = Vue.component('editor', {
    template: '#editor',
    data: editorData,
});

function editorData() {
    return {
      tab: null,
      develop: [[.Develop]],
      script: null,
    }
}
</script>