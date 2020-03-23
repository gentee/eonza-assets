<script type="text/x-template" id="card">
    <div class="pa-6" style="max-height: 100%;overflow-y: auto;border-left: 2px solid #ddd;">
     <v-text-field v-model="active.name"
    label="[[lang "name"]]" 
    ></v-text-field>

    <p>Ooops {{active.name}}
    dsdsdsdsds wed nweijd wedhb wejdb wedbwedbwe jdwebdjhwebdjhwb dwejhdbwejhdb wjhdbwejhbwe djhwebdjh   we b djhwebd  jhwbdjhwbdwjhdb wjhdbwjhdbw ejhbwedjhwebdjh d
    </p>
    <p>Ooops {{active.name}}
    dsdsdsdsds wed nweijd wedhb wejdb wedbwedbwe jdwebdjhwebdjhwb dwejhdbwejhdb wjhdbwejhbwe djhwebdjh   we b djhwebd  jhwbdjhwbdwjhdb wjhdbwjhdbw ejhbwedjhwebdjh d
    </p>
    </div>
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