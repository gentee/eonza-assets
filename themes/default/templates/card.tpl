<script type="text/x-template" id="card">
    <v-container elevation-1 class="pa-6">
    <span>Ooops
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
});

function cardData() {
    return {
    }
}

</script>