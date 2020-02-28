<script type="text/x-template" id="editor">
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <v-btn color="primary" @click="value++;">Editor {{value}}</v-btn>
    </v-layout>
  </v-container>
</script>

<script>
const Editor = Vue.component('editor', {
    template: '#editor',
    data: editorData,
});

function editorData() {
    return {
      value: 0,
    }
}
</script>