<script type="text/x-template" id="home">
  <v-container fluid>
    <v-tabs v-model="tab">
        <v-tab>[[lang "search"]]</v-tab>
        <v-tab>[[lang "recently"]]</v-tab>
    </v-tabs>

     <v-tabs-items v-model="tab">
       <v-tab-item>  
        1
       </v-tab-item>
       <v-tab-item >
         2
        </v-tab-item>
    </v-tabs-items>

    <v-layout align-center justify-center>
      <v-btn color="primary">Home</v-btn>
    </v-layout>
  </v-container>
</script>

<script>
const Home = {
  template: '#home',
  data: homeData,
};

function homeData() {
    return {
        tab: null,
    }
}
</script>
