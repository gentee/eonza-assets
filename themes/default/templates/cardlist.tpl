<script type="text/x-template" id="cardlist">
    <div class="d-flex flex-wrap" 
       style="max-height:calc(100% - 106px);overflow-y: auto;">
    <!--div-->
         <v-card
          v-for="(item, i) in list"
          :key="i" style="max-width: 350px;"
          class="ma-2 d-flex flex-column justify-space-between"
        > 
          <v-card-title v-text="item.title"></v-card-title>
          <v-card-subtitle v-text="desc(item)"></v-card-subtitle>
          <div class="d-flex justify-space-around mb-2 align-end">
          <v-btn class="ma-2" color="primary" small v-if="!item.unrun" @click="$root.run(item.name)">
           <v-icon left small>fa-play</v-icon> [[lang "run"]]
          </v-btn>
          <v-tooltip top>
            <template v-slot:activator="{ on }">
                          <v-btn @click="edit(item.name)" icon color="primary" v-on="on"  >
                              <v-icon>fa-edit</v-icon>
                          </v-btn>
            </template>
            <span>[[lang "edit"]]</span>
          </v-tooltip>
          </div>
        </v-card>
    </div>
</script>

<script>
Vue.component('cardlist', {
    template: '#cardlist',
    methods: {
        edit(name) {
        this.$router.push('/editor?scriptname=' + name);
        },
    },
    props: {
        list: Array,
    },
});
</script>