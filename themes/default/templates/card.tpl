<script type="text/x-template" id="card">
    <v-container elevation-1 class="pa-6">
     <v-text-field v-model="active.name"
    label="[[lang "name"]]" 
    ></v-text-field>

    <span>Ooops {{active.name}}
    dsdsdsdsds wed nweijd wedhb wejdb wedbwedbwe jdwebdjhwebdjhwb dwejhdbwejhdb wjhdbwejhbwe djhwebdjh   we b djhwebd  jhwbdjhwbdwjhdb wjhdbwjhdbw ejhbwedjhwebdjh d
    </span>
    </v-container>
</script>

<script>

Vue.component('card', {
    template: '#card',
    data: cardData,
    props: {
//        item: Object,
    },
    computed: {
        active: {
            get() { return store.state.active },
            set(value) { store.commit('updateActive', value) }
        },
    },

});

function cardData() {
    return {
    }
}

</script>