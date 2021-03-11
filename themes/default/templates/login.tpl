<!DOCTYPE html>
<html>
<head> 
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>[[ .App.Title ]]</title>
  <link rel="icon" href="/favicon.ico" type="image/x-icon"> 
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="/css/vuetify.min.css">
  <link rel="stylesheet" href="/css/fontawesome.min.css">
  <link rel="stylesheet" href="/css/eonza.css">
  <!--link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet"-->
</head>
<body>
<div id = "app" >
         <v-app>
         <div  style="height: 100%; display: flex;justify-content: center;align-items: center;
              background-color: #ccc;">
       <div style="max-width: 600px;min-width: 350px;background-color: #fff;border: 1px solid #aaa;
         padding: 2rem 1rem;
         display:flex;justify-content: center;align-items:center;flex-direction: column;">
          
          <div style="display: flex;justify-content:center;align-items:center;margin-bottom: 2rem;">
          <img src="/images/logo-48.png" style="width: 48px;height:48px;">
          <div style="font-size: 2rem;color: #777;margin-left: 1rem;">[[if .Title]][[.Title]][[else]][[.App.Title]][[end]]</div>
          </div>
          <v-text-field
            v-model="password" name="password"
            :append-icon="show1 ? 'fa-eye' : 'fa-eye-slash'"
                :type="show1 ? 'text' : 'password'"
            label="%password%"
            outlined style="width: 250px;"
            hint="" 
            @click:append="show1 = !show1"
          ></v-text-field>
          <img v-show="twofaqr" :src="twofaqr" style="margin-bottom: 1em;">
          <v-text-field v-show="twofa"
            v-model="otp" name="otp"
            label="%onetimepass%"
            outlined style="width: 250px;"
            hint="" 
          ></v-text-field>
          <v-alert type="error" v-show="error">
              %invalidpsw%
          </v-alert>
           <v-btn color="primary" @click="submit">%login%</v-btn>
           <a :href="restorepsw" target="_help" style="margin-top: 1.5rem;">%forgotpsw%</a>
       </div>
       </div>
          </v-app>
</div>
<script src="/js/vue.min.js"></script>
<script src="/js/vuetify.min.js"></script>
<script src="/js/axios.min.js"></script>

<script>

new Vue({
    vuetify: new Vuetify({
      icons: {
        iconfont: 'fa',// || 'faSvg'
      },
    }),
    el: '#app',
    data: appData,
    methods: {
        keyProcess(event) {
            if (event.keyCode == 13) {
                this.submit();
            }
        },
       submit() {
        if (!this.password) {
          return
        }
        this.error = false
        const formData = new FormData();
        formData.set('password', this.password)
        formData.set('otp', this.otp)
        axios({
              method: 'post',
              url: '/api/login',
              data: formData
              })
        .then(response => { 
          if (response.data.twofa) {
            this.twofaqr = response.data.twofaqr
            this.twofa = true
          } else if (!response.data.error) {
              let d = new Date();
              d.setTime(d.getTime() + 5 * 1000 /* 5sec */);
              let expires = "expires=" + d.toUTCString();
              document.cookie = "hashid=" + response.data.id + ";" + expires + ";path=/";
              window.removeEventListener('keydown', this.keyProcess);
              //window.location = '/'
              location.reload()
          } 
          if (response.data.error) {
            this.error = true
            console.log(response.data.error)
          }
        });
      },
    },
    mounted() {
      window.addEventListener('keydown', this.keyProcess);
    },
    computed: {
        restorepsw() { 
            let pref = [[.Lang]]
            if (pref == 'en') {
              pref = ''
            }
            return "https://www.eonza.org/" + pref +  "docs/restore-password.html"
        },
    }
})

function appData() { 
    return {
        show1: false,
        password: '',
        twofaqr: '',
        otp: '',
        twofa: false,
        error: false
    }
}
</script>

</body>
</html>

